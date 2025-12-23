import 'dart:io';
import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/model/owner_model.dart';
import 'package:booknex_partner/features/partner_onboarding/model/business_model.dart';
import 'package:booknex_partner/features/partner_onboarding/model/location_model.dart';
import 'package:booknex_partner/features/partner_onboarding/model/ground_model.dart';
import 'package:booknex_partner/features/partner_onboarding/model/bank_model.dart';
import 'package:booknex_partner/features/partner_onboarding/model/terms_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentPageIndex = 0;
  bool _isNavigating = false;
  bool _isLive = false;

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseStorage get _storage => FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final Map<String, String?> errors = {};

  // Models
  final OwnerModel owner = OwnerModel();
  final BusinessModel business = BusinessModel();
  final LocationModel location = LocationModel();
  final List<GroundModel> grounds = [];
  final BankModel bank = BankModel();
  final TermsModel terms = TermsModel();

  int groundCount = 1;
  String? selectedSport;
  String? selectedGroundType;

  // Controllers (Managed by ViewModel as requested)
  // Shared across repeating screens by updating values upon navigation
  final TextEditingController groundNameController = TextEditingController();
  final TextEditingController groundSizeController = TextEditingController();
  final TextEditingController maxPlayersController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Location Controllers
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  // Owner Controllers
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Bank Controllers
  final TextEditingController bankAccountHolderController =
      TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController bankAccountNumberController =
      TextEditingController();
  final TextEditingController bankIfscController = TextEditingController();
  final TextEditingController bankUpiController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // Auth State
  String? _verificationId;
  bool _isOtpSent = false;
  bool _isPhoneVerified = false;
  bool _isAuthLoading = false;

  bool get isOtpSent => _isOtpSent;
  bool get isPhoneVerified => _isPhoneVerified;
  bool get isAuthLoading => _isAuthLoading;

  OnboardingViewModel() {
    _initGrounds();
    _setupValidators();
    if (_auth.currentUser != null) {
      _isPhoneVerified = true;
    }
  }

  void _setupValidators() {
    groundNameController.addListener(
      () => validateField('groundName', groundNameController.text),
    );
    groundSizeController.addListener(
      () => validateField('groundSize', groundSizeController.text),
    );
    maxPlayersController.addListener(
      () => validateField('maxPlayers', maxPlayersController.text),
    );
    branchNameController.addListener(
      () => validateField('branchName', branchNameController.text),
    );
    addressController.addListener(
      () => validateField('address', addressController.text),
    );
    cityController.addListener(
      () => validateField('city', cityController.text),
    );
    stateController.addListener(
      () => validateField('state', stateController.text),
    );
    pincodeController.addListener(
      () => validateField('pincode', pincodeController.text),
    );
    ownerNameController.addListener(
      () => validateField('ownerName', ownerNameController.text),
    );
    mobileController.addListener(
      () => validateField('mobile', mobileController.text),
    );
    priceController.addListener(
      () => validateField('price', priceController.text),
    );
    bankAccountHolderController.addListener(
      () => validateField('accountHolder', bankAccountHolderController.text),
    );
    bankNameController.addListener(
      () => validateField('bankName', bankNameController.text),
    );
    bankAccountNumberController.addListener(
      () => validateField('accountNumber', bankAccountNumberController.text),
    );
    bankIfscController.addListener(
      () => validateField('ifsc', bankIfscController.text),
    );
  }

  void validateField(String field, String value) {
    String? error;
    if (value.isEmpty) {
      error = "Field cannot be empty";
    } else {
      switch (field) {
        case 'mobile':
          if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
            error = "Invalid 10-digit number";
          }
          break;
        case 'pincode':
          if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
            error = "Invalid 6-digit pincode";
          }
          break;
        case 'ifsc':
          if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value)) {
            error = "Invalid IFSC code";
          }
          break;
        case 'price':
        case 'maxPlayers':
        case 'accountNumber':
          if (double.tryParse(value) == null) error = "Must be a number";
          break;
      }
    }

    if (errors[field] != error) {
      errors[field] = error;
      notifyListeners();
    }
  }

  void _initGrounds() {
    grounds.clear();
    for (int i = 0; i < groundCount; i++) {
      grounds.add(GroundModel(id: 'ground_$i'));
    }
  }

  int get currentPageIndex => _currentPageIndex;
  bool get isLive => _isLive;

  // Total steps logic:
  // 1: Hook, 2: Sport, 3: Type, 4: Count
  // + (groundCount * 2) [Details & Availability]
  // + 1: Location, 1: Pricing (Per Hour), 1: Amenities, 1: Media, 1: Owner, 1: Bank, 1: Terms, 1: Status
  int get totalSteps => 4 + (groundCount * 2) + 8;

  void updateStep(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void nextPage() async {
    if (_isNavigating) return;
    if (_currentPageIndex < totalSteps - 1) {
      // Validate Owner Details step for phone verification
      int groundStepsEnd = 4 + (groundCount * 2);
      int remainingOffset = _currentPageIndex - groundStepsEnd;

      if (remainingOffset == 4 && !_isPhoneVerified) {
        errors['mobile'] = "Please verify your mobile number first";
        notifyListeners();
        return;
      }

      _isNavigating = true;
      // Sync current controllers to models before moving if necessary
      _saveCurrentStepData();
      await pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _loadStepData(_currentPageIndex);
      _saveDraft(); // Incrementally save after navigation
      _isNavigating = false;
    }
  }

  void previousPage() async {
    if (_isNavigating) return;
    if (_currentPageIndex > 0) {
      // Don't allow going back from status screen if it's already live
      if (_isLive) return;
      _isNavigating = true;
      await pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _loadStepData(_currentPageIndex);
      _isNavigating = false;
    }
  }

  void _saveCurrentStepData() {
    // Current ground index calculation if applicable
    int groundStepsStart = 4;
    int groundStepsEnd = groundStepsStart + (groundCount * 2);

    // If we're on the status screen, don't save anything
    if (_currentPageIndex >= totalSteps - 1) return;

    if (_currentPageIndex >= groundStepsStart &&
        _currentPageIndex < groundStepsEnd) {
      int offset = _currentPageIndex - groundStepsStart;
      int groundIndex = offset ~/ 2;
      bool isDetails = offset % 2 == 0;

      if (isDetails) {
        grounds[groundIndex].name = groundNameController.text;
        grounds[groundIndex].size = groundSizeController.text;
        grounds[groundIndex].maxPlayers =
            int.tryParse(maxPlayersController.text) ?? 0;
      }
    } else {
      // Handle static screens
      int remainingOffset = _currentPageIndex - groundStepsEnd;
      if (_currentPageIndex == 1) {
        // Sport selection saved directly via setSport
      } else if (_currentPageIndex == 2) {
        // Ground type saved directly via setGroundType
      } else if (remainingOffset == 0) {
        // Location
        location.branchName = branchNameController.text;
        location.address = addressController.text;
        location.landmark = landmarkController.text;
        location.pincode = pincodeController.text;
        location.city = cityController.text;
        location.state = stateController.text;
      } else if (remainingOffset == 1) {
        // Pricing
        double price = double.tryParse(priceController.text) ?? 0;
        for (var g in grounds) {
          g.pricePerHour = price;
        }
      } else if (remainingOffset == 4) {
        // Owner
        owner.name = ownerNameController.text;
        owner.mobile = mobileController.text;
        owner.email = emailController.text;
      } else if (remainingOffset == 5) {
        // Bank
        bank.accountHolderName = bankAccountHolderController.text;
        bank.bankName = bankNameController.text;
        bank.accountNumber = bankAccountNumberController.text;
        bank.ifscCode = bankIfscController.text;
        bank.upiId = bankUpiController.text;
      }
    }
  }

  void _loadStepData(int index) {
    int groundStepsStart = 4;
    int groundStepsEnd = groundStepsStart + (groundCount * 2);

    if (index >= groundStepsStart && index < groundStepsEnd) {
      int offset = index - groundStepsStart;
      int groundIndex = offset ~/ 2;
      bool isDetails = offset % 2 == 0;

      if (isDetails) {
        groundNameController.text = grounds[groundIndex].name;
        groundSizeController.text = grounds[groundIndex].size;
        maxPlayersController.text = (grounds[groundIndex].maxPlayers ?? 0) > 0
            ? grounds[groundIndex].maxPlayers.toString()
            : "";
      }
    }
    // Static screens generally don't need re-loading for this simple flow
    // unless the user goes back to them.
  }

  // State update methods
  void setSport(String sport) {
    selectedSport = sport;
    for (var g in grounds) {
      g.sport = sport;
    }
    notifyListeners();
  }

  void setGroundType(String type) {
    selectedGroundType = type;
    for (var g in grounds) {
      g.type = type;
    }
    notifyListeners();
  }

  void updateGroundCount(int count) {
    groundCount = count;
    _initGrounds();
    notifyListeners();
  }

  Future<void> submitData() async {
    // 1. Final sync and move to status screen
    _saveCurrentStepData();
    nextPage();

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not authenticated");

      // 2. Upload media files individually (Ground 0 for now as per view)
      final List<String> imageUrls = [];
      for (var path in grounds[0].imagePaths) {
        if (path.startsWith('http')) {
          imageUrls.add(path); // Already uploaded
          continue;
        }

        try {
          final file = File(path);
          final ref = _storage.ref().child(
            'partners/${user.uid}/ground_0/${DateTime.now().millisecondsSinceEpoch}_${path.split('/').last}',
          );
          await ref.putFile(file);
          final url = await ref.getDownloadURL();
          imageUrls.add(url);
        } catch (e) {
          debugPrint("Failed to upload $path: $e");
          // Continue with others as per user request (handle failure per file)
        }
      }

      grounds[0].imagePaths = imageUrls;

      // 3. Update Firestore with final URLs and status
      await _firestore.collection('partners').doc(user.uid).update({
        'grounds': grounds.map((g) => g.toMap()).toList(),
        'status': 'SUBMITTED',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _isLive = true;
    } catch (e) {
      debugPrint("Submission error: $e");
      errors['submission'] = "Failed to submit: ${e.toString()}";
    } finally {
      notifyListeners();
    }
  }

  Future<void> _saveDraft() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final data = {
        'ownerId': user.uid,
        'owner': owner.toMap(),
        'location': location.toMap(),
        'grounds': grounds.map((g) => g.toMap()).toList(),
        'bank': bank.toMap(),
        'terms': terms.toMap(),
        'status': 'DRAFT',
        'updatedAt': FieldValue.serverTimestamp(),
        'currentStep': _currentPageIndex,
      };

      await _firestore
          .collection('partners')
          .doc(user.uid)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Draft save error: $e");
    }
  }

  void toggleTerms(bool? value) {
    terms.isAccepted = value ?? false;
    notifyListeners();
  }

  void setSurfaceType(int index, String? type) {
    grounds[index].surfaceType = type;
    notifyListeners();
  }

  void setIndoor(int index, bool value) {
    grounds[index].isIndoor = value;
    notifyListeners();
  }

  void setFloodlights(int index, bool value) {
    grounds[index].hasFloodlights = value;
    notifyListeners();
  }

  void setParking(bool value) {
    location.hasParking = value;
    notifyListeners();
  }

  void setOpeningTime(int index, TimeOfDay time) {
    grounds[index].openingTime = time;
    notifyListeners();
  }

  void setClosingTime(int index, TimeOfDay time) {
    grounds[index].closingTime = time;
    notifyListeners();
  }

  void toggleOperatingDay(int index, String day) {
    if (grounds[index].operatingDays.contains(day)) {
      grounds[index].operatingDays.remove(day);
    } else {
      grounds[index].operatingDays.add(day);
    }
    notifyListeners();
  }

  void setAmenity(String a, bool v) {
    for (var g in grounds) {
      g.amenities[a] = v;
    }
    notifyListeners();
  }

  void setWhatsappOptIn(bool v) {
    owner.whatsappOptIn = v;
    notifyListeners();
  }

  // Media & Map methods
  Future<void> pickImages(int groundIndex) async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      grounds[groundIndex].imagePaths = images.map((e) => e.path).toList();
      notifyListeners();
    }
  }

  void updateCoordinates(double lat, double lng) {
    location.latitude = lat;
    location.longitude = lng;
    notifyListeners();
  }

  // Integrated Auth Methods
  Future<void> sendOtp() async {
    final phone = mobileController.text.trim();
    if (phone.length != 10) {
      errors['mobile'] = "Enter a valid 10-digit number";
      notifyListeners();
      return;
    }

    _isAuthLoading = true;
    errors['mobile'] = null;
    notifyListeners();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91$phone", // Assuming India, adjust as needed
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          _isPhoneVerified = true;
          _isOtpSent = false;
          _isAuthLoading = false;
          notifyListeners();
        },
        verificationFailed: (FirebaseAuthException e) {
          errors['mobile'] = e.message;
          _isAuthLoading = false;
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _isOtpSent = true;
          _isAuthLoading = false;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      errors['mobile'] = e.toString();
      _isAuthLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp() async {
    final code = otpController.text.trim();
    if (code.length != 6) {
      errors['otp'] = "Enter 6-digit OTP";
      notifyListeners();
      return;
    }

    _isAuthLoading = true;
    errors['otp'] = null;
    notifyListeners();

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: code,
      );
      await _auth.signInWithCredential(credential);
      _isPhoneVerified = true;
      _isOtpSent = false;
      _isAuthLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errors['otp'] = e.message;
      _isAuthLoading = false;
      notifyListeners();
    } catch (e) {
      errors['otp'] = e.toString();
      _isAuthLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    groundNameController.dispose();
    groundSizeController.dispose();
    maxPlayersController.dispose();
    priceController.dispose();
    branchNameController.dispose();
    addressController.dispose();
    landmarkController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    ownerNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    bankAccountHolderController.dispose();
    bankNameController.dispose();
    bankAccountNumberController.dispose();
    bankIfscController.dispose();
    bankUpiController.dispose();
    super.dispose();
  }
}
