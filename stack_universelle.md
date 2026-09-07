# **🛠 Documentation de la Stack Technique (Architecture Universelle)**

Ce document décrit l'architecture technique de référence, conçue pour être **AI-Native**, **File-Based**, modulaire et unifiée. Cette stack permet de déployer une plateforme cross-platform (Web, PWA, iOS, Android) dotée de capacités géospatiales avancées et d'une structure de données hautement polymorphique.

## **1\. Vue d'Ensemble de l'Architecture**

L'architecture s'appuie sur une séparation claire mais technologiquement alignée (Full-Stack TypeScript recommandé) :

* **Frontend Universel :** Rendu unique pour le Web, iOS et Android via un routeur basé sur le système de fichiers.  
* **Backend Conteneurisé :** API performante et légère, fortement typée.  
* **Persistance Géospatiale :** Base de données relationnelle intégrant nativement les calculs spatiaux complexes.  
* **DevOps & Déploiement :** Infrastructure as Code (Docker) et compilation mobile déportée dans le cloud.

## **2\. Frontend : Application Web & Mobile Native**

La couche présentation est unifiée pour maximiser la réutilisation du code entre les environnements Web et Mobiles.

* **Framework Core :** React Native avec **Expo**.  
* **Routage :** **Expo Router** (Routage File-Based permettant une gestion universelle des URL sur Web et des Deep Links sur Mobile).  
* **Web & SEO :** Support du *Static Rendering* / *Server-Side Rendering (SSR)* pour garantir l'indexation par les moteurs de recherche (génération automatisée de sitemaps).  
* **Développement Live :** Lancement de l'environnement de développement via la commande npx expo start \-c (exécution sur simulateurs, appareils physiques ou navigateur web).

### **Centralisation de l'Environnement API**

L'application consomme une configuration réseau stricte pour les requêtes backend :

* Les variables d'environnement sont injectées via le fichier .env (ex: EXPO\_PUBLIC\_API\_URL=https://api.votre-domaine.com).  
* Mécanisme de fallback interne dans le code (config.ts) et possibilité d'injection dynamique lors des phases de compilation CI/CD.

## **3\. Backend : API & ORM**

Le serveur applicatif est conçu pour être rapide, modulaire et synchronisé avec les types du frontend.

* **Framework API :** **Hono (TypeScript)** (ou alternative FastAPI en Python). Hono est privilégié pour maintenir une stack Full-TypeScript.  
* **ORM (Object-Relational Mapping) :** **Drizzle ORM**. Permet une modélisation déclarative des schémas (dans src/db/schema.ts) et une synchronisation absolue des types de données de la base jusqu'à l'interface utilisateur sans génération de code intermédiaire.

## **4\. Base de Données & Moteur Géospatial**

La persistance des données repose sur une base relationnelle robuste et extensible.

* **SGBD :** **PostgreSQL 16**.  
* **Extension Spatiale :** **PostGIS** (postgis/postgis:16-3.4).  
  * Apporte le typage spatial natif (ex: GEOGRAPHY(Point, 4326)).  
  * Indexation spatiale avancée (GIST).  
  * Calculs de proximité et de rayons instantanés (via ST\_DWithin, ST\_DistanceSphere).

### **Paradigmes de Modélisation de Données**

Le modèle relationnel s'appuie sur des concepts avancés pour garantir une flexibilité métier totale :

1. **Système Polymorphique EAV (Entity-Attribute-Value) :** Utilisation d'un modèle d'entités "Informations" rattachables dynamiquement à n'importe quel objet de la base via un couple (target\_type, target\_id).  
2. **Machine à États (State Pattern) :** Implémentation d'un historique immuable des statuts (Brouillon, Publié, Archivé, etc.) pour chaque objet, agissant comme un *Audit Trail* et un gestionnaire de visibilité par événement.  
3. **Structures Récursives :** Support de hiérarchies (arbres SQL avec WITH RECURSIVE) pour modéliser des catégories ou taxonomies imbriquées à l'infini (via des clés parent\_id).

## **5\. Sécurité & Authentification**

L'approche de sécurité vise à éliminer les frictions tout en garantissant la robustesse :

* **Authentification "Frictionless" :**  
  * Génération de codes PIN sécurisés ou Magic Links.  
  * Hachage cryptographique côté serveur (Argon2 ou Bcrypt).  
  * Maintien de la session via un jeton sécurisé, stocké dans un cookie HttpOnly et couplé à une empreinte IP.  
* **Résilience :**  
  * Rate-limiting strict (ex: blocage après N tentatives infructueuses par IP).  
  * Optimisation des index (notamment composites sur les tables polymorphiques) pour éviter les attaques par déni de service (DDoS) sur des requêtes lourdes.

## **6\. Pipeline de Compilation Mobile (CI/CD)**

Le projet utilise l'écosystème **EAS (Expo Application Services)** pour externaliser et simplifier la génération des binaires natifs, sans nécessiter Xcode ou Android Studio en local.

### **Compilation Cloud (EAS Build)**

Des profils de build sont configurés (ex: dans eas.json) pour l'intégration continue et la distribution :

* **Android (APK) \- Installation directe :**  
  eas build \--platform android \--profile preview  
* **Android (AAB) \- Déploiement Play Store :**  
  eas build \--platform android \--profile production  
* **iOS (Tarball) \- Simulateur :**  
  eas build \--platform ios \--profile preview-simulator  
* **iOS (IPA) \- Déploiement App Store / TestFlight :**  
  eas build \--platform ios \--profile production

### **Compilation Locale (Prebuild / Bare workflow)**

Pour des besoins spécifiques (hors cloud), la génération locale reste possible :

1. Génération des dossiers natifs : npx expo prebuild \--clean  
2. Build Android : cd android && ./gradlew assembleRelease (APK) ou ./gradlew bundleRelease (AAB).

## **7\. Infrastructure & Déploiement (DevOps)**

L'ensemble des services (API, Base de données PostgreSQL/PostGIS) est isolé et orchestré de manière "File-Based".

* **Orchestration :** **Docker & Docker Compose**.  
* **Configuration :** Un fichier central compose.yaml décrit les services, les réseaux internes et les ports exposés.  
* **Persistance & Sauvegarde :** Les données de la base résident dans des volumes montés localement (ex: ./data/postgres). Les sauvegardes s'effectuent par simple script (pg\_dump compressé) ou snapshot du volume.  
* **Déploiement Unifié :** Le lancement de l'infrastructure backend complète se fait en une commande unique : docker compose up \--build \-d.