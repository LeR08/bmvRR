import 'package:flutter/foundation.dart';
import '../models/user.dart';

/// Service utilisateur mocké pour tester l'app sans Firebase
class MockUserService {
  AppUser? _currentUser;

  Future<AppUser?> getUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentUser;
  }

  Future<void> createUser(AppUser user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = user;
    debugPrint('🎭 DEMO MODE: User created');
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('🎭 DEMO MODE: User updated');
  }

  Future<AppUser?> getUserByPartnerCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 400));
    debugPrint('🎭 DEMO MODE: Partner lookup by code: $code');

    // Retourner un partenaire fictif
    return AppUser(
      uid: 'partner_demo_456',
      email: 'partner@example.com',
      displayName: 'Partenaire Démo',
      subscriptionTier: SubscriptionTier.free,
      partnerId: null,
      partnerInviteCode: 'PART2026',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
      stats: UserStats(
        quizzesCompleted: 8,
        totalTimeSpentMinutes: 95,
        daysStreak: 3,
        lastQuizDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
    );
  }

  Future<void> linkPartner(String userId, String partnerId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('🎭 DEMO MODE: Partner linked: $userId <-> $partnerId');
  }

  Future<void> unlinkPartner(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint('🎭 DEMO MODE: Partner unlinked');
  }

  Future<void> updateSubscription(
    String userId,
    SubscriptionTier tier, {
    DateTime? expiresAt,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    debugPrint('🎭 DEMO MODE: Subscription updated to ${tier.name}');
  }

  Future<void> incrementQuizCompleted(String userId, int timeSpentMinutes) async {
    await Future.delayed(const Duration(milliseconds: 200));
    debugPrint('🎭 DEMO MODE: Quiz stats incremented');
  }

  Future<void> updateStreak(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    debugPrint('🎭 DEMO MODE: Streak updated');
  }
}
