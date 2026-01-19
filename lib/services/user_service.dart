import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../config/firebase_config.dart';
import '../models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Créer un utilisateur
  Future<void> createUser(AppUser user) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.id)
          .set(user.toJson());
    } catch (e) {
      debugPrint('Error creating user: $e');
      rethrow;
    }
  }

  // Récupérer un utilisateur
  Future<AppUser?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        return AppUser.fromJson(doc.data()!);
      }
    } catch (e) {
      debugPrint('Error getting user: $e');
    }
    return null;
  }

  // Stream d'un utilisateur
  Stream<AppUser?> getUserStream(String userId) {
    return _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return AppUser.fromJson(doc.data()!);
      }
      return null;
    });
  }

  // Mettre à jour un utilisateur
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .update(data);
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  // Mettre à jour le lastLoginAt
  Future<void> updateLastLogin(String userId) async {
    await updateUser(userId, {
      'lastLoginAt': DateTime.now().toIso8601String(),
    });
  }

  // Supprimer un utilisateur
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .delete();
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }

  // Associer un partenaire
  Future<void> linkPartner(String userId, String partnerCode) async {
    try {
      // Chercher le partenaire par son code d'invitation
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.users)
          .where('partnerInviteCode', isEqualTo: partnerCode)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Code d\'invitation invalide');
      }

      final partnerId = querySnapshot.docs.first.id;

      if (partnerId == userId) {
        throw Exception('Vous ne pouvez pas vous associer avec vous-même');
      }

      // Vérifier que le partenaire n'a pas déjà un partenaire
      final partnerData = querySnapshot.docs.first.data();
      if (partnerData['partnerId'] != null) {
        throw Exception('Ce partenaire est déjà associé');
      }

      // Associer les deux utilisateurs
      await _firestore.runTransaction((transaction) async {
        final userRef = _firestore
            .collection(FirestoreCollections.users)
            .doc(userId);
        final partnerRef = _firestore
            .collection(FirestoreCollections.users)
            .doc(partnerId);

        transaction.update(userRef, {'partnerId': partnerId});
        transaction.update(partnerRef, {'partnerId': userId});
      });
    } catch (e) {
      debugPrint('Error linking partner: $e');
      rethrow;
    }
  }

  // Dissocier un partenaire
  Future<void> unlinkPartner(String userId, String partnerId) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final userRef = _firestore
            .collection(FirestoreCollections.users)
            .doc(userId);
        final partnerRef = _firestore
            .collection(FirestoreCollections.users)
            .doc(partnerId);

        transaction.update(userRef, {'partnerId': null});
        transaction.update(partnerRef, {'partnerId': null});
      });
    } catch (e) {
      debugPrint('Error unlinking partner: $e');
      rethrow;
    }
  }

  // Mettre à jour l'abonnement
  Future<void> updateSubscription(
    String userId,
    SubscriptionTier tier,
    DateTime expiresAt,
  ) async {
    await updateUser(userId, {
      'subscriptionTier': tier.name,
      'subscriptionExpiresAt': expiresAt.toIso8601String(),
    });
  }

  // Mettre à jour les statistiques
  Future<void> updateStats(String userId, UserStats stats) async {
    await updateUser(userId, {
      'stats': stats.toJson(),
    });
  }

  // Incrémenter le compteur de quiz complétés
  Future<void> incrementQuizCompleted(String userId, int timeSpentMinutes) async {
    try {
      final userDoc = await _firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final user = AppUser.fromJson(userDoc.data()!);
        final newStats = UserStats(
          quizzesCompleted: user.stats.quizzesCompleted + 1,
          totalTimeSpentMinutes: user.stats.totalTimeSpentMinutes + timeSpentMinutes,
          daysStreak: _calculateStreak(user.stats.lastQuizCompletedAt),
          lastQuizCompletedAt: DateTime.now(),
          categoriesCompleted: user.stats.categoriesCompleted,
        );
        await updateStats(userId, newStats);
      }
    } catch (e) {
      debugPrint('Error incrementing quiz completed: $e');
    }
  }

  int _calculateStreak(DateTime? lastQuizDate) {
    if (lastQuizDate == null) return 1;

    final now = DateTime.now();
    final lastQuiz = DateTime(lastQuizDate.year, lastQuizDate.month, lastQuizDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final difference = today.difference(lastQuiz).inDays;

    if (difference == 0) {
      // Même jour, pas d'incrément
      return 1;
    } else if (difference == 1) {
      // Jour suivant, incrémenter
      return 1; // Will be incremented by caller
    } else {
      // Plus d'un jour, réinitialiser
      return 1;
    }
  }
}
