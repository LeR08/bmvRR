/// Configuration de l'application
class AppConfig {
  // Mode démo : active les services mockés sans Firebase
  // Changez cette valeur à `false` une fois Firebase configuré
  static const bool isDemoMode = true;

  // Afficher des logs de débogage
  static const bool showDebugLogs = true;

  // Configuration Firebase (à remplir quand Firebase est configuré)
  static const String firebaseApiKey = 'YOUR_API_KEY';
  static const String firebaseAppId = 'YOUR_APP_ID';
  static const String firebaseMessagingSenderId = 'YOUR_SENDER_ID';
  static const String firebaseProjectId = 'YOUR_PROJECT_ID';

  // Configuration AdMob (à remplir quand AdMob est configuré)
  static const String androidBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Test ID
  static const String iosBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716'; // Test ID
  static const String androidInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String iosInterstitialAdUnitId = 'ca-app-pub-3940256099942544/4411468910'; // Test ID

  static void printConfig() {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🎭 MODE DÉMO: ${isDemoMode ? 'ACTIVÉ ✅' : 'DÉSACTIVÉ ❌'}');
    if (isDemoMode) {
      print('');
      print('L\'application fonctionne en mode démo.');
      print('Aucune configuration Firebase n\'est requise.');
      print('Toutes les données sont mockées localement.');
      print('');
      print('Pour utiliser Firebase en production :');
      print('1. Configurez Firebase (voir SETUP.md)');
      print('2. Changez isDemoMode à false dans app_config.dart');
    }
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}
