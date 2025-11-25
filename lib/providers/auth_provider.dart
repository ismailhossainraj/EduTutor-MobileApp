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

  Future<bool> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String? department,
    String? className,
    String? gender,
    UserRole role,
  ) async {
    _setLoading(true);
    try {
      final user = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        department: department,
        className: className,
        gender: gender,
        role: role,
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
