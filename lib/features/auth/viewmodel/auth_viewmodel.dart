import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;
  String? _error;
  String? _verificationId;

  AuthViewModel() {
    try {
      _auth.authStateChanges().listen((user) {
        _user = user;
        notifyListeners();
      });
    } catch (e) {
      debugPrint("AuthViewModel: Firebase not initialized $e");
    }
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> verifyPhone(
    String phoneNumber, {
    required Function(String code) onCodeSent,
    required Function(String error) onError,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _error = e.message;
          onError(e.message ?? "Verification failed");
          _setLoading(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent(verificationId);
          _setLoading(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      _error = e.toString();
      onError(e.toString());
      _setLoading(false);
    }
  }

  Future<bool> confirmOtp(String smsCode) async {
    if (_verificationId == null) return false;
    _setLoading(true);
    _clearError();

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
