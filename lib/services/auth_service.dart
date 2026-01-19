import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  // Stream de l'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Inscription avec email et mot de passe
  Future<AppUser?> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Créer le profil utilisateur dans Firestore
        final appUser = AppUser(
          id: userCredential.user!.uid,
          email: email,
          displayName: displayName,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
          partnerInviteCode: _generateInviteCode(),
        );

        await _userService.createUser(appUser);

        // Mettre à jour le display name
        if (displayName != null) {
          await userCredential.user!.updateDisplayName(displayName);
        }

        return appUser;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Sign up error: ${e.code} - ${e.message}');
      rethrow;
    }
    return null;
  }

  // Connexion avec email et mot de passe
  Future<AppUser?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Mettre à jour le lastLoginAt
        await _userService.updateLastLogin(userCredential.user!.uid);
        return await _userService.getUser(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Sign in error: ${e.code} - ${e.message}');
      rethrow;
    }
    return null;
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint('Reset password error: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Supprimer le compte
  Future<void> deleteAccount() async {
    final user = currentUser;
    if (user != null) {
      await _userService.deleteUser(user.uid);
      await user.delete();
    }
  }

  // Générer un code d'invitation unique
  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    String code = '';
    int value = random;

    for (int i = 0; i < 6; i++) {
      code += chars[value % chars.length];
      value ~/= chars.length;
    }

    return code;
  }

  // Récupérer les erreurs Firebase Auth en français
  String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé';
      case 'invalid-email':
        return 'Email invalide';
      case 'operation-not-allowed':
        return 'Opération non autorisée';
      case 'weak-password':
        return 'Le mot de passe est trop faible';
      case 'user-disabled':
        return 'Ce compte a été désactivé';
      case 'user-not-found':
        return 'Aucun compte trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessayez plus tard';
      default:
        return 'Une erreur est survenue: ${e.message}';
    }
  }
}
