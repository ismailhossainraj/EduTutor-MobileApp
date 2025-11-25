import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _checkCurrentUser();
  }
  Future<void> _checkCurrentUser() async {
    _setLoading(true);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      _user = await _authService.getUserInfo(currentUserId);
    }
    _setLoading(false);
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final user = await _authService.loginWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        // Fetch user info from Firestore
        _user = await _authService.getUserInfo(user.uid);
      } else {
        _user = null;
      }
      _setLoading(false);
      return _user != null;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? gender,
    required UserRole role,
    // Student specific fields
    String? schoolName,
    String? classLevel,
    // Teacher specific fields
    String? college,
    String? educationLevel,
    String? university,
    String? interest,
    String? phoneNumber,
  }) async {
    _setLoading(true);
    try {
      final user = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        role: role,
        schoolName: schoolName,
        classLevel: classLevel,
        college: college,
        educationLevel: educationLevel,
        university: university,
        interest: interest,
        phoneNumber: phoneNumber,
      );
      if (user != null) {
        _user = await _authService.getUserInfo(user.uid);
      } else {
        _user = null;
      }
      _setLoading(false);
      return _user != null;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
