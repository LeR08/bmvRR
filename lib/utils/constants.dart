import 'package:flutter/material.dart';

class AppColors {
  // Couleurs principales
  static const Color primary = Color(0xFFFF6B9D); // Rose romantique
  static const Color primaryDark = Color(0xFFE5537F);
  static const Color secondary = Color(0xFF4A90E2); // Bleu doux
  static const Color accent = Color(0xFFFFC837); // Jaune chaleureux

  // Couleurs de fond
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Couleurs de texte
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF6C6C6C);
  static const Color textLight = Colors.white;

  // Couleurs d'état
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coupleGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppBorderRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double circular = 999.0;
}

class AppConstants {
  // Pagination
  static const int quizzesPerPage = 20;
  static const int resultsPerPage = 10;

  // Durées
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration splashDuration = Duration(seconds: 2);

  // Quiz
  static const int minQuestionsPerQuiz = 10;
  static const int maxQuestionsPerQuiz = 15;
  static const int scaleMin = 1;
  static const int scaleMax = 5;

  // Ads
  static const int quizzesBeforeInterstitialAd = 3; // Afficher pub tous les 3 quiz

  // Abonnements (prix en euros)
  static const String soloPrice = '4.99€/mois';
  static const String couplePrice = '9.99€/mois';
  static const String elitePrice = '19.99€/mois';
  static const String lifetimePrice = '99.99€';
}

class AppStrings {
  // Navigation
  static const String home = 'Accueil';
  static const String profile = 'Profil';
  static const String history = 'Historique';
  static const String partner = 'Partenaire';
  static const String subscription = 'Abonnement';

  // Quiz
  static const String startQuiz = 'Commencer';
  static const String nextQuestion = 'Suivant';
  static const String previousQuestion = 'Précédent';
  static const String finishQuiz = 'Terminer';
  static const String quizCompleted = 'Quiz terminé !';
  static const String viewResults = 'Voir les résultats';
  static const String shareWithPartner = 'Partager avec mon partenaire';

  // Auth
  static const String signIn = 'Se connecter';
  static const String signUp = 'S\'inscrire';
  static const String signOut = 'Se déconnecter';
  static const String email = 'Email';
  static const String password = 'Mot de passe';
  static const String confirmPassword = 'Confirmer le mot de passe';
  static const String displayName = 'Nom d\'affichage';
  static const String forgotPassword = 'Mot de passe oublié ?';

  // Erreurs
  static const String errorGeneric = 'Une erreur est survenue';
  static const String errorNetwork = 'Erreur de connexion';
  static const String errorAuth = 'Erreur d\'authentification';
  static const String errorPermission = 'Vous n\'avez pas accès à ce contenu';
  static const String errorSubscriptionRequired = 'Abonnement requis';

  // Abonnements
  static const String free = 'Gratuit';
  static const String solo = 'Solo Premium';
  static const String couple = 'Couple Premium';
  static const String elite = 'Elite';
  static const String lifetime = 'À vie';
  static const String upgrade = 'Mettre à niveau';
  static const String subscribe = 'S\'abonner';

  // Partner
  static const String invitePartner = 'Inviter mon partenaire';
  static const String partnerCode = 'Code partenaire';
  static const String enterPartnerCode = 'Entrer le code';
  static const String copyCode = 'Copier le code';
  static const String partnerLinked = 'Partenaire associé !';
}

// Extensions utilitaires
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}

extension DateTimeExtension on DateTime {
  String toRelativeString() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Il y a $years an${years > 1 ? 's' : ''}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Il y a $months mois';
    } else if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }
}
