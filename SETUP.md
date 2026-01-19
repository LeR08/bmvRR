# Guide de configuration

## Configuration Firebase

### 1. Créer un projet Firebase

1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Créez un nouveau projet
3. Activez Authentication (Email/Password)
4. Créez une base de données Firestore

### 2. Configuration Android

1. Dans Firebase Console, ajoutez une application Android
2. Package name : `com.example.couples_distance_app` (ou votre package)
3. Téléchargez le fichier `google-services.json`
4. Placez-le dans `android/app/google-services.json`

### 3. Configuration iOS

1. Dans Firebase Console, ajoutez une application iOS
2. Bundle ID : `com.example.couplesDistanceApp`
3. Téléchargez le fichier `GoogleService-Info.plist`
4. Placez-le dans `ios/Runner/GoogleService-Info.plist`

### 4. Configuration des Firebase Options

Modifiez le fichier `lib/config/firebase_config.dart` avec vos propres clés :

```dart
static FirebaseOptions _getFirebaseOptions() {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return const FirebaseOptions(
      apiKey: 'VOTRE_ANDROID_API_KEY',
      appId: 'VOTRE_ANDROID_APP_ID',
      messagingSenderId: 'VOTRE_MESSAGING_SENDER_ID',
      projectId: 'VOTRE_PROJECT_ID',
      storageBucket: 'VOTRE_STORAGE_BUCKET',
    );
  }
  // ... iOS config
}
```

## Configuration Google AdMob

### 1. Créer un compte AdMob

1. Allez sur [AdMob](https://admob.google.com/)
2. Créez une application
3. Créez des unités publicitaires (Banner, Interstitial, Rewarded)

### 2. Configurer les IDs

Modifiez le fichier `lib/services/ads_service.dart` avec vos IDs :

```dart
String get bannerAdUnitId {
  if (Platform.isAndroid) {
    return 'ca-app-pub-XXXXX/XXXXX'; // Votre ID Android
  } else if (Platform.isIOS) {
    return 'ca-app-pub-XXXXX/XXXXX'; // Votre ID iOS
  }
}
```

### 3. Configuration Android

Ajoutez dans `android/app/src/main/AndroidManifest.xml` :

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXX~XXXXX"/>
```

### 4. Configuration iOS

Ajoutez dans `ios/Runner/Info.plist` :

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXX~XXXXX</string>
```

## Configuration In-App Purchases

### Android

1. Configurez Google Play Console
2. Créez vos produits d'abonnement
3. Testez avec des comptes de test

### iOS

1. Configurez App Store Connect
2. Créez vos produits d'abonnement
3. Testez avec des comptes Sandbox

## Charger les quiz depuis Firestore

Pour charger les quiz depuis le fichier JSON vers Firestore :

```dart
// Exemple de script pour uploader les quiz
Future<void> uploadQuizzesToFirestore() async {
  final String jsonString = await rootBundle.loadString('assets/quiz/quizzes.json');
  final List<dynamic> jsonList = json.decode(jsonString);

  final firestore = FirebaseFirestore.instance;

  for (final quizJson in jsonList) {
    final quiz = Quiz.fromJson(quizJson);
    await firestore
        .collection('quizzes')
        .doc(quiz.id)
        .set(quiz.toJson());
  }
}
```

## Lancer l'application

```bash
# Installer les dépendances
flutter pub get

# Lancer sur un émulateur/appareil
flutter run

# Build pour production
flutter build apk  # Android
flutter build ios  # iOS
```

## Structure des données Firestore

### Collections

- `users` : Utilisateurs de l'application
- `quizzes` : Liste des quiz disponibles
- `quiz_results` : Résultats des quiz
- `quiz_series` : Séries/parcours de quiz
- `series_progress` : Progression des utilisateurs dans les séries
- `subscriptions` : Informations d'abonnement

### Règles de sécurité Firestore (exemple)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users peuvent lire/écrire leur propre profil
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Tous peuvent lire les quiz
    match /quizzes/{quizId} {
      allow read: if request.auth != null;
      allow write: if false; // Admin seulement
    }

    // Users peuvent lire/écrire leurs résultats
    match /quiz_results/{resultId} {
      allow read, write: if request.auth != null &&
        resource.data.userId == request.auth.uid;
    }
  }
}
```

## Notes importantes

- **Ne committez JAMAIS** vos fichiers `google-services.json` ou `GoogleService-Info.plist`
- **Ne committez JAMAIS** vos clés API dans le code
- Utilisez des variables d'environnement pour les clés sensibles en production
- Testez toujours avec les IDs de test AdMob en développement
