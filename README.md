# Couples Distance App 💑

Application mobile pour couples en relation à distance.

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
