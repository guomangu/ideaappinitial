# **🚀 Architecture Technique : La Stack "AI-Native" & "File-Based"**

Ce document présente l'architecture technique choisie pour notre projet. La philosophie centrale de cette stack est l'approche **"File-Based" (basée sur les fichiers)** et **"AI-Driven" (pensée pour l'IA)**.  
L'objectif est d'éviter toute interface graphique complexe ou IDE lourd (comme Xcode, Android Studio ou les consoles cloud complexes) qu'un agent IA ne peut pas manipuler. Tout le comportement de l'application (routage, base de données, infrastructure) doit pouvoir être lu, compris et modifié via de simples fichiers texte.

## **📱 1\. Frontend Mobile (iOS & Android)**

La création de l'interface mobile s'appuie sur des technologies hautement documentées dont la génération de code par l'IA est extrêmement fiable.

> * **Framework Core :** **React Native**  
> * **Boîte à outils et Routage :** **Expo & Expo Router**  
  * *L'approche "File-Based" :* Le routage est dicté par l'arborescence des fichiers. Par exemple, le fichier app/profil/index.tsx crée automatiquement l'écran de profil. L'IA comprend parfaitement cette logique spatiale de navigation.  
  * *Configuration unifiée :* Toute la configuration native (icônes, permissions, nom de l'app) est centralisée dans un seul fichier app.json.  
> * **Compilation :** **Locale et Open Source**. Au lieu d'utiliser des services cloud complexes, la compilation se fait en local via les commandes npx expo run:android ou npx expo run:ios, totalement scriptables par un agent.

## **⚙️ 2\. Backend (API & Logique Métier)**

Le backend est conçu pour être léger, rapide à lire pour une IA et déployable n'importe où sans friction.

> * **Moteur API :** **Hono (TypeScript) ou FastAPI (Python)**  
  * **Si Hono :** Idéal pour conserver un écosystème 100% TypeScript (Fullstack). Chaque route peut être définie dans un fichier indépendant, ultra-léger et compatible avec les environnements Edge (Cloudflare Workers, Bun, etc.).  
  * **Si FastAPI :** Génère automatiquement le fichier openapi.json (Swagger). Ce fichier agit comme un "mode d'emploi" parfait. L'agent IA n'a qu'à lire ce fichier JSON pour comprendre exactement comment interagir avec l'API, quels endpoints existent et quels formats de données envoyer.

## **💾 3\. Base de Données & ORM (Stockage)**

C'est ici que l'approche "As a File" prend tout son sens. Aucune base de données distante complexe ou serveur lourd à configurer.

> * **Base de Données :** **SQLite**  
  * *L'approche "File-Based" :* La base de données est littéralement un fichier local (ex: database.sqlite). L'agent IA peut lire ce fichier, faire des requêtes locales pour vérifier ses développements, ou le dupliquer (test.sqlite) pour faire des tests destructifs sans casser l'environnement principal.  
> * **ORM (Object-Relational Mapping) :** **Prisma ou Drizzle ORM**  
  * *L'approche "File-Based" :* Toute la structure de la base de données (tables, relations, index) est définie de manière déclarative dans un seul fichier texte (ex: schema.prisma pour Prisma ou un fichier .ts pour Drizzle). L'IA lit ce fichier unique et comprend instantanément toute l'architecture de la donnée, sans avoir à interroger un serveur SQL.

## **🐳 4\. Infrastructure & Déploiement**

Le déploiement et l'environnement d'exécution doivent suivre la même logique : tout doit être codé dans des fichiers.

> * **Conteneurisation :** **Docker**  
> * **Orchestration locale :** **Docker Compose**  
  * *L'approche "File-Based" :* Toute l'infrastructure (serveur backend, configuration réseau, volumes pour le fichier SQLite) est décrite dans un unique fichier compose.yaml.  
  * *Avantage IA :* L'agent IA n'a pas besoin de naviguer sur AWS ou un panel de serveur. S'il a besoin d'ajouter une variable d'environnement ou de modifier un port, il lui suffit d'éditer le fichier texte compose.yaml et de relancer la commande docker compose up.

### **🎯 Résumé des avantages pour le développement assisté par IA :**

> 1. **Contexte réduit :** L'IA trouve l'information rapidement (le routage dans les dossiers, la BDD dans un schéma, l'infra dans le docker-compose).  
> 2. **Autonomie :** Aucune action manuelle sur des interfaces graphiques n'est requise.  
> 3. **Prédictibilité :** Le typage fort (TypeScript/Python) et les contrats stricts (OpenAPI) limitent drastiquement les hallucinations.