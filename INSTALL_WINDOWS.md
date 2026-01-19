# Guide d'installation Flutter sur Windows

## 📋 Prérequis système

- Windows 10 ou supérieur (64-bit)
- Espace disque : au moins 2.5 GB
- Git pour Windows

## 🚀 Étapes d'installation

### 1️⃣ Installer Git (si pas déjà installé)

Téléchargez et installez Git depuis : https://git-scm.com/download/win

### 2️⃣ Télécharger Flutter SDK

**Option A : Téléchargement direct (Recommandé)**

1. Allez sur https://docs.flutter.dev/get-started/install/windows
2. Téléchargez le fichier ZIP du Flutter SDK
3. Extrayez le fichier dans un dossier (par exemple `C:\src\flutter`)
   - ⚠️ **N'installez PAS dans `C:\Program Files\`** (problèmes de permissions)

**Option B : Avec Git**

```cmd
cd C:\src
git clone https://github.com/flutter/flutter.git -b stable
```

### 3️⃣ Ajouter Flutter au PATH

1. Cherchez "Variables d'environnement" dans le menu Démarrer
2. Cliquez sur "Modifier les variables d'environnement système"
3. Cliquez sur "Variables d'environnement..."
4. Dans "Variables utilisateur", trouvez la variable `Path` et cliquez sur "Modifier"
5. Cliquez sur "Nouveau" et ajoutez : `C:\src\flutter\bin` (ou votre chemin d'installation)
6. Cliquez sur "OK" sur toutes les fenêtres

### 4️⃣ Vérifier l'installation

Ouvrez une **NOUVELLE** invite de commande (PowerShell ou CMD) et tapez :

```cmd
flutter --version
```

Vous devriez voir la version de Flutter s'afficher.

### 5️⃣ Exécuter Flutter Doctor

```cmd
flutter doctor
```

Cette commande vérifie votre configuration et vous indique ce qui manque.

## 📱 Configurer un émulateur ou appareil

### Option 1 : Émulateur Android (Android Studio)

1. **Téléchargez Android Studio** : https://developer.android.com/studio
2. **Installez Android Studio** et suivez l'assistant d'installation
3. **Lancez Android Studio**
4. Allez dans **Tools > Device Manager**
5. Cliquez sur **Create Device**
6. Choisissez un appareil (ex: Pixel 6)
7. Téléchargez une image système (ex: Android 13)
8. Créez l'émulateur

**Accepter les licences Android :**
```cmd
flutter doctor --android-licenses
```

### Option 2 : Appareil physique Android

1. Activez les **Options développeur** sur votre téléphone :
   - Allez dans **Paramètres > À propos du téléphone**
   - Tapez 7 fois sur **Numéro de build**
2. Activez le **Débogage USB** :
   - **Paramètres > Options développeur > Débogage USB**
3. Connectez votre téléphone en USB
4. Autorisez le débogage USB sur le téléphone

### Option 3 : Chrome (Web) - Le plus simple pour tester !

**Aucune configuration supplémentaire nécessaire !** Chrome est déjà installé.

```cmd
flutter run -d chrome
```

## ✅ Installation complète

Une fois Flutter installé, dans le dossier du projet :

```cmd
# 1. Se déplacer dans le dossier du projet
cd C:\Users\Romain\Desktop\bmvRR-main

# 2. Installer les dépendances
flutter pub get

# 3. Vérifier les appareils disponibles
flutter devices

# 4. Lancer l'app (choisir une option)

# Option A : Sur Chrome (le plus rapide pour tester)
flutter run -d chrome

# Option B : Sur émulateur Android
flutter run

# Option C : Sur appareil physique connecté
flutter run
```

## 🐛 Problèmes courants

### "flutter n'est pas reconnu"
- ✅ Avez-vous ajouté Flutter au PATH ?
- ✅ Avez-vous ouvert une NOUVELLE invite de commande après avoir modifié le PATH ?
- ✅ Redémarrez votre ordinateur si le problème persiste

### Android Studio ne détecte pas l'émulateur
```cmd
flutter emulators
flutter emulators --launch <emulator_id>
```

### Erreur de licences Android
```cmd
flutter doctor --android-licenses
```
Acceptez toutes les licences en tapant "y"

## 🎯 Test rapide avec Chrome

**La méthode la plus rapide pour tester l'app sans installation Android :**

```cmd
cd C:\Users\Romain\Desktop\bmvRR-main
flutter pub get
flutter run -d chrome
```

L'application s'ouvrira dans Chrome en mode démo ! 🎉

## 📞 Besoin d'aide ?

Vérifiez votre configuration :
```cmd
flutter doctor -v
```

Cette commande affiche tous les détails de votre installation.

## 🔗 Ressources

- Documentation Flutter : https://docs.flutter.dev/get-started/install/windows
- Tutoriels vidéo : https://www.youtube.com/c/flutterdev
- Discord Flutter FR : https://discord.gg/flutter
