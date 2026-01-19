import 'package:flutter/foundation.dart';
import '../models/user.dart';

/// Service d'authentification mocké pour tester l'app sans Firebase
class MockAuthService {
  // Utilisateur de démo
  static final AppUser demoUser = AppUser(
    uid: 'demo_user_123',
    email: 'demo@example.com',
    displayName: 'Utilisateur Démo',
    photoUrl: null,
    subscriptionTier: SubscriptionTier.free,
    partnerId: null,
    partnerInviteCode: 'DEMO2026',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    lastLoginAt: DateTime.now(),
    stats: UserStats(
      quizzesCompleted: 12,
      totalTimeSpentMinutes: 145,
      daysStreak: 5,
      lastQuizDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  );

  Future<AppUser?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 800));

    // Accepter n'importe quel email/mot de passe pour la démo
    if (email.isNotEmpty && password.length >= 6) {
      debugPrint('🎭 DEMO MODE: Sign in successful');
      return demoUser;
    }

    throw Exception('Email ou mot de passe invalide');
  }

  Future<AppUser?> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    // Simuler un délai réseau
    await Future.delayed(const Duration(milliseconds: 1000));

    if (email.isNotEmpty && password.length >= 6 && displayName.isNotEmpty) {
      debugPrint('🎭 DEMO MODE: Sign up successful');
      return demoUser.copyWith(
        email: email,
        displayName: displayName,
      );
    }

    throw Exception('Erreur lors de l\'inscription');
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('🎭 DEMO MODE: Sign out successful');
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('🎭 DEMO MODE: Password reset email sent to $email');
  }

  Future<AppUser?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return demoUser;
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('🎭 DEMO MODE: Profile updated');
  }

  Stream<AppUser?> authStateChanges() {
    return Stream.value(demoUser);
  }
}
