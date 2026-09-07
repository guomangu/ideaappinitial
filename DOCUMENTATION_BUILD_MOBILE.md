# 📱 Guide Pratique de Compilation Mobile Native (Android & iOS) — JobShop.com

Ce guide détaille l'ensemble des commandes et des configurations pour générer, compiler et distribuer l'application mobile native **JobShop.com** sur **Android (APK / AAB)** et **iOS (Simulateur / IPA)** avec l'écosystème **Expo & React Native**.

---

## 📑 Sommaire
1. [Centralisation de l'URL de l'API Backend](#1-centralisation-de-lurl-de-lapi-backend)
2. [Prérequis & Installation des Outils](#2-prérequis--installation-des-outils)
3. [Méthode 1 : Compilation Cloud avec EAS Build (Recommandée)](#3-méthode-1--compilation-cloud-avec-eas-build-recommandée)
4. [Méthode 2 : Compilation Locale Hors-Cloud (Expo Prebuild / Bare)](#4-méthode-2--compilation-locale-hors-cloud-expo-prebuild--bare)
5. [Méthode 3 : Exécution en Développement Live (Expo Go & Dev Client)](#5-méthode-3--exécution-en-développement-live-expo-go--dev-client)
6. [Résolution des Problèmes Réseau & Dépannage (Troubleshooting)](#6-résolution-des-problèmes-réseau--dépannage-troubleshooting)

---

## 1. Centralisation de l'URL de l'API Backend

L'adresse de l'API est entièrement centralisée dans [`frontend/src/api/config.ts`](file:///home/gamo/Documents/ilovemyjobs/frontend/src/api/config.ts). Tous les appels réseau ([`client.ts`](file:///home/gamo/Documents/ilovemyjobs/frontend/src/api/client.ts), [`communes.ts`](file:///home/gamo/Documents/ilovemyjobs/frontend/src/api/communes.ts)) consomment cette source unique.

### Configuration de l'URL de production :

L'URL officielle de production est configurée par défaut sur :
`https://api.localitica.sweaw.com`

#### Option A : Fichier `.env` (Recommandé)
Le fichier `frontend/.env` est configuré ainsi :
```ini
EXPO_PUBLIC_API_URL=https://api.localitica.sweaw.com
```

#### Option B : Variable en ligne de commande lors du build
Vous pouvez injecter l'URL directement dans la commande de build :
```bash
EXPO_PUBLIC_API_URL="https://api.localitica.sweaw.com" eas build --platform android --profile production
```

#### Option C : Fallback dans le code source
Dans [`frontend/src/api/config.ts`](file:///home/gamo/Documents/ilovemyjobs/frontend/src/api/config.ts), `DEFAULT_REMOTE_API_URL` pointe directement vers `https://api.localitica.sweaw.com`.

---

## 2. Prérequis & Installation des Outils

### Outils CLI Universels
Assurez-vous de disposer de Node.js (v18+) et installez les outils Expo :
```bash
npm install -g eas-cli
eas --version
```

### Pour la compilation locale Android :
- **Java JDK :** OpenJDK 17 recommandé (`sudo apt install openjdk-17-jdk` sur Ubuntu/Debian).
- **Android SDK & Command-line Tools :** Installés via Android Studio.
- Variables d'environnement configurées (`$ANDROID_HOME` et `$PATH`).

### Pour la compilation locale iOS :
- **macOS uniquement** avec Xcode installé (App Store).
- Command Line Tools Xcode : `xcode-select --install`.
- Gestionnaire de dépendances CocoaPods : `sudo gem install cocoapods`.

---

## 3. Méthode 1 : Compilation Cloud avec EAS Build (Recommandée)

Cette méthode ne nécessite **aucune installation d'Android Studio ni de Xcode** sur votre poste de travail. Les binaires sont générés sur les serveurs sécurisés d'Expo.

### Étape 1 : Connexion à votre compte Expo
```bash
cd frontend
eas login
```

### Étape 2 : Configuration du projet EAS
Le fichier [`frontend/eas.json`](file:///home/gamo/Documents/ilovemyjobs/frontend/eas.json) est préconfiguré avec les profils suivants :
- `preview` : Génère un fichier `.apk` autonome installable directement sur tout smartphone Android.
- `preview-simulator` : Génère une archive `.tar.gz` pour le simulateur iOS.
- `production` : Génère un `.aab` (Android App Bundle pour Google Play) avec `versionCode: 1` et un `.ipa` (App Store).

---

### 🤖 Commandes de Build Android (EAS Cloud)

#### Générer un APK Android (Installation directe sur téléphone) :
```bash
cd frontend
eas build --platform android --profile preview
```

#### Générer un AAB Android (Publication Google Play Store) :
```bash
cd frontend
eas build --platform android --profile production
```
> **Assets Play Store associés :** Voir [`frontend/PLAY_STORE_METADATA.md`](file:///home/gamo/Documents/ilovemyjobs/frontend/PLAY_STORE_METADATA.md).
> - Icône 512x512 : `frontend/assets/images/play-store-icon-512.png`
> - Bannière 1024x500 : `frontend/assets/images/play-store-feature-graphic-1024x500.png`

---

### 🍏 Commandes de Build iOS (EAS Cloud)

#### Générer un build iOS pour simulateur :
```bash
cd frontend
eas build --platform ios --profile preview-simulator
```

#### Générer un IPA iOS (TestFlight / App Store) :
```bash
cd frontend
eas build --platform ios --profile production
```

---

## 4. Méthode 2 : Compilation Locale Hors-Cloud (Expo Prebuild / Bare)

```bash
cd frontend
npx expo prebuild --clean
```

### Compiler l'APK Android en local
```bash
cd frontend/android
./gradlew assembleRelease
```

### Compiler l'AAB Android (Google Play) en local
```bash
cd frontend/android
./gradlew bundleRelease
```
> **Localisation de l'AAB généré :**
> `frontend/android/app/build/outputs/bundle/release/app-release.aab`

---

## 5. Méthode 3 : Exécution en Développement Live

```bash
cd frontend
npx expo start -c
```
- **Sur Android :** Touche `a`.
- **Sur iOS :** Touche `i`.
- **Sur Web :** Touche `w`.

---

## 6. Résolution des Problèmes Réseau & Dépannage (Troubleshooting)

### A. Erreur `fetch failed 10.0.2.2 not permitted` sur Android
Cette erreur survient quand :
1. L'application mobile tente de joindre `10.0.2.2` en HTTP non chiffré alors que le système Android bloque le trafic en clair (`Cleartext HTTP traffic not permitted`).
2. L'URL d'API distante n'était pas injectée dans le bundle.
**Solution appliquée :**
- `DEFAULT_REMOTE_API_URL` dans [`frontend/src/api/config.ts`](file:///home/gamo/Documents/ilovemyjobs/frontend/src/api/config.ts) pointe désormais vers `https://api.localitica.sweaw.com` (HTTPS sécurisé).
- Le fichier `frontend/.env` et les profils `eas.json` injectent automatiquement `EXPO_PUBLIC_API_URL=https://api.localitica.sweaw.com`.

### B. Autorisations de Géolocalisation (WGS84)
Dans [`frontend/app.json`](file:///home/gamo/Documents/ilovemyjobs/frontend/app.json) :
- **Android :** `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, `INTERNET`.
- **iOS :** `NSLocationWhenInUseUsageDescription`.

---

## 🚀 Résumé des Commandes Rapides

| Action | Commande |
| :--- | :--- |
| **Configurer l'URL API** | `frontend/.env` -> `EXPO_PUBLIC_API_URL=https://api.localitica.sweaw.com` |
| **Lancer en dev** | `cd frontend && npx expo start -c` |
| **Générer APK Android (Cloud)** | `cd frontend && eas build -p android --profile preview` |
| **Générer AAB Play Store (Cloud)** | `cd frontend && eas build -p android --profile production` |
| **Générer iOS Simulateur (Cloud)** | `cd frontend && eas build -p ios --profile preview-simulator` |
| **Générer iOS IPA (Cloud)** | `cd frontend && eas build -p ios --profile production` |
| **Compiler AAB localement** | `cd frontend/android && ./gradlew bundleRelease` |
