import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/mock_auth_service.dart';
import '../services/mock_user_service.dart';
import '../services/user_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService? _authService = AppConfig.isDemoMode ? null : AuthService();
  final UserService? _userService = AppConfig.isDemoMode ? null : UserService();
  final MockAuthService? _mockAuthService = AppConfig.isDemoMode ? MockAuthService() : null;
  final MockUserService? _mockUserService = AppConfig.isDemoMode ? MockUserService() : null;

  User? _firebaseUser;
  AppUser? _appUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get firebaseUser => _firebaseUser;
  AppUser? get appUser => _appUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => AppConfig.isDemoMode ? _appUser != null : _firebaseUser != null;

  AuthProvider() {
    if (AppConfig.isDemoMode) {
      // En mode démo, connecter automatiquement l'utilisateur de démo
      _loadDemoUser();
    } else {
      _authService!.authStateChanges.listen(_onAuthStateChanged);
    }
  }

  Future<void> _loadDemoUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _appUser = MockAuthService.demoUser;
    notifyListeners();
  }

  void _onAuthStateChanged(User? user) async {
    _firebaseUser = user;

    if (user != null) {
      // Charger les données utilisateur
      _appUser = await _userService!.getUser(user.uid);
    } else {
      _appUser = null;
    }

    notifyListeners();
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (AppConfig.isDemoMode) {
        _appUser = await _mockAuthService!.signUpWithEmailAndPassword(
          email,
          password,
          displayName ?? 'Utilisateur',
        );
      } else {
        _appUser = await _authService!.signUpWithEmail(
          email: email,
          password: password,
          displayName: displayName,
        );
      }

      _isLoading = false;
      notifyListeners();
      return _appUser != null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = AppConfig.isDemoMode ? e.toString() : _authService!.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Une erreur est survenue';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (AppConfig.isDemoMode) {
        _appUser = await _mockAuthService!.signInWithEmailAndPassword(email, password);
      } else {
        _appUser = await _authService!.signInWithEmail(
          email: email,
          password: password,
        );
      }

      _isLoading = false;
      notifyListeners();
      return _appUser != null;
    } on FirebaseAuthException catch (e) {
      _errorMessage = AppConfig.isDemoMode ? e.toString() : _authService!.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Une erreur est survenue';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    if (AppConfig.isDemoMode) {
      await _mockAuthService!.signOut();
    } else {
      await _authService!.signOut();
    }
    _firebaseUser = null;
    _appUser = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (AppConfig.isDemoMode) {
        await _mockAuthService!.sendPasswordResetEmail(email);
      } else {
        await _authService!.resetPassword(email);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = AppConfig.isDemoMode ? e.toString() : _authService!.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Une erreur est survenue';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshUser() async {
    if (AppConfig.isDemoMode) {
      if (_appUser != null) {
        _appUser = await _mockUserService!.getUser(_appUser!.uid);
        notifyListeners();
      }
    } else {
      if (_firebaseUser != null) {
        _appUser = await _userService!.getUser(_firebaseUser!.uid);
        notifyListeners();
      }
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
