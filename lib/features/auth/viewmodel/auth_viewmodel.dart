import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'
    show ChangeNotifier, kIsWeb, defaultTargetPlatform, TargetPlatform;

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;
  String? _error;
  String? _verificationId;
  bool _isOtpSent = false;
  ConfirmationResult? _webConfirmationResult;

  AuthViewModel() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isOtpSent => _isOtpSent;

  Future<void> sendOtp(String phone) async {
    if (phone.length != 10) {
      _error = "Enter a valid 10-digit number";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (kIsWeb) {
        _webConfirmationResult = await _auth.signInWithPhoneNumber(
          "+91$phone",
          RecaptchaVerifier(
            container: 'recaptcha-container',
            auth: _auth as dynamic,
          ),
        );
        _isOtpSent = true;
      } else if (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux) {
        _error =
            "Phone authentication is not supported on this platform (${defaultTargetPlatform.name}). Please test on Android, iOS, or Web.";
        _isLoading = false;
        notifyListeners();
        return;
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: "+91$phone",
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            _isLoading = false;
            notifyListeners();
          },
          verificationFailed: (FirebaseAuthException e) {
            _error = e.message;
            _isLoading = false;
            notifyListeners();
          },
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
            _isOtpSent = true;
            _isLoading = false;
            notifyListeners();
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    } finally {
      if (kIsWeb) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> verifyOtp(String code) async {
    if (code.length != 6) {
      _error = "Enter 6-digit OTP";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (kIsWeb && _webConfirmationResult != null) {
        await _webConfirmationResult!.confirm(code);
      } else if (_verificationId != null) {
        final credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: code,
        );
        await _auth.signInWithCredential(credential);
      } else {
        throw Exception("Verification ID missing");
      }
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  void reset() {
    _isOtpSent = false;
    _verificationId = null;
    _webConfirmationResult = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
