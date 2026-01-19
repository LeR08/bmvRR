# Couples Distance App 💑

Application mobile pour couples en relation à distance.

## 🎭 MODE DÉMO - Testez sans Firebase !

L'application est configurée par défaut en **mode démo** pour que vous puissiez la tester immédiatement **sans configuration Firebase**.

### ✅ Avantages du mode démo :
- 🚀 **Aucune configuration requise** - L'app fonctionne immédiatement
- 📦 **Données mockées** - 5 quiz d'exemple préchargés
- 🔐 **Connexion simplifiée** - Utilisez n'importe quel email/mot de passe (min. 6 caractères)
- 💾 **Pas de backend** - Toutes les données restent locales
- 🎨 **Interface complète** - Testez toutes les fonctionnalités UI

### 🧪 Comment tester en mode démo :

**⚠️ Si Flutter n'est pas installé sur votre système :**
- **Windows** → Consultez [INSTALL_WINDOWS.md](INSTALL_WINDOWS.md) - Guide complet
- **macOS/Linux** → https://docs.flutter.dev/get-started/install

**Une fois Flutter installé :**

```bash
# Cloner le repo (si pas déjà fait)
git clone https://github.com/LeR08/bmvRR.git
cd bmvRR

# Installer les dépendances
flutter pub get

# Option 1 : Lancer dans Chrome (le plus rapide)
flutter run -d chrome

# Option 2 : Lancer sur émulateur/appareil Android
flutter run
```

**C'est tout ! L'application se lance en mode démo automatiquement.**

Vous verrez une bannière "🎭 MODE DÉMO" en haut à droite de l'écran.

### 🔄 Passer en mode production :

Une fois Firebase configuré (voir [SETUP.md](SETUP.md)) :

1. Ouvrir `lib/config/app_config.dart`
2. Changer `isDemoMode` de `true` à `false`
3. Relancer l'app

```dart
// lib/config/app_config.dart
static const bool isDemoMode = false; // ← Changer ici
```

---

## 🎯 Fonctionnalités

### V1 (MVP)
- ✅ Quiz interactifs (10-15 questions)
- ✅ Système d'abonnement (Free, Solo, Couple)
- ✅ Publicités (tier gratuit)
- ✅ Authentification utilisateur
- ✅ Historique des quiz
- ✅ Mode solo et couple

### V2 (À venir)
- ⏳ Parcours relationnels
- ⏳ Tests de personnalité
- ⏳ Profils relationnels
- ⏳ Abonnement Elite

### V3 (Futur)
- ⏳ Défis hebdomadaires
- ⏳ Contenus événementiels
- ⏳ Offre à vie

## 🏗️ Architecture

```
lib/
├── main.dart                 # Point d'entrée
├── models/                   # Modèles de données
├── services/                 # Services (Firebase, Ads, etc.)
├── providers/                # State management (Provider)
├── screens/                  # Écrans de l'app
├── widgets/                  # Widgets réutilisables
├── utils/                    # Utilitaires et constantes
└── config/                   # Configuration (Firebase, etc.)
```

## 🚀 Installation

### Prérequis
- Flutter SDK (>=3.0.0)
- Firebase project configuré
- Xcode (pour iOS)
- Android Studio (pour Android)

### Setup

1. Cloner le repository
```bash
git clone <repo-url>
cd couples_distance_app
```

2. Installer les dépendances
```bash
flutter pub get
```

3. Configurer Firebase
   - Ajouter `google-services.json` (Android) dans `android/app/`
   - Ajouter `GoogleService-Info.plist` (iOS) dans `ios/Runner/`

4. Lancer l'application
```bash
flutter run
```

## 📦 Modèle économique

| Tier | Prix | Fonctionnalités |
|------|------|-----------------|
| **Free** | Gratuit | Quiz fun, publicités, accès limité |
| **Solo Premium** | 💰 | Quiz précis, historique, sans pub |
| **Couple Premium** | 💰💰 | Mode synchronisé, débriefs complets |
| **Elite** | 💰💰💰💰 | Contenus exclusifs, défis avancés |
| **Lifetime** | 💎 | Accès complet à vie |

## 🔐 Sécurité

- Données privées chiffrées
- Authentification Firebase
- Pas de conseils médicaux
- Contenu validé humainement

## 🌍 Langues supportées

- 🇫🇷 Français
- 🇬🇧 English (à venir)

## 📊 KPI

- Conversion > 5%
- Rétention J30 > 25%
- Temps moyen > 7 min
- Coût IA = 0€ en production

## 📝 License

Proprietary - Tous droits réservés
