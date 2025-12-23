import 'package:flutter/material.dart';
import 'package:booknex_partner/features/partner_onboarding/model/owner_model.dart';
import 'package:booknex_partner/features/partner_onboarding/model/business_model.dart';
import 'package:booknex_partner/features/partner_onboarding/model/location_model.dart';
import 'package:booknex_partner/features/partner_onboarding/model/ground_model.dart';
import 'package:booknex_partner/features/partner_onboarding/model/bank_model.dart';
import 'package:booknex_partner/features/partner_onboarding/model/terms_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentPageIndex = 0;
  bool _isNavigating = false;

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

  OnboardingViewModel() {
    _initGrounds();
  }

  void _initGrounds() {
    grounds.clear();
    for (int i = 0; i < groundCount; i++) {
      grounds.add(GroundModel(id: 'ground_$i'));
    }
  }

  int get currentPageIndex => _currentPageIndex;

  // Total steps logic:
  // 1: Hook, 2: Sport, 3: Type, 4: Count
  // + (groundCount * 2) [Details & Availability]
  // + 1: Location, 1: Pricing (Per Hour), 1: Amenities, 1: Media, 1: Owner, 1: Bank/Terms
  int get totalSteps => 4 + (groundCount * 2) + 7;

  void updateStep(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  void nextPage() async {
    if (_isNavigating) return;
    if (_currentPageIndex < totalSteps - 1) {
      _isNavigating = true;
      // Sync current controllers to models before moving if necessary
      _saveCurrentStepData();
      await pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _loadStepData(_currentPageIndex);
      _isNavigating = false;
    }
  }

  void previousPage() async {
    if (_isNavigating) return;
    if (_currentPageIndex > 0) {
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
