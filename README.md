# 🚀 Projet Coolove - Stack "AI-Driven" & "File-Based"

Ce projet utilise une architecture pensée spécifiquement pour le développement assisté par IA. L'objectif est d'éviter toute interface complexe (pas d'IDE lourd, pas de consoles cloud opaques) : tout le comportement de l'application se comprend et se modifie via des fichiers textes simples.

## 🌟 Présentation de la Stack

*   **📱 Frontend (React Native + Expo)** : Routage basé sur les fichiers (Expo Router). L'IA comprend la logique spatiale.
*   **⚙️ Backend (Hono + TypeScript)** : API ultra-légère, documentée, 100% typée.
*   **💾 Base de données (SQLite + Prisma)** : Approche "As a File". La structure (schéma) et les données tiennent dans de simples fichiers locaux.
*   **🐳 Infrastructure (Podman/Docker)** : Orchestration locale complète (base de données, backend) définie dans `compose.yaml`.

---

## 🛠️ Tutoriel de démarrage rapide

Nous avons créé un script d'automatisation pour simplifier au maximum le lancement.

### 1. Démarrer le projet

À la racine du projet, exécutez simplement :
```bash
./start.sh
```

Ce script s'occupe de tout :
1. Il lance le **Backend** via Podman (`podman-compose up -d backend`). L'API sera accessible sur `http://localhost:3000`.
2. Il installe automatiquement les dépendances du **Frontend** si ce n'est pas déjà fait.

### 2. Lancer l'application Mobile (Frontend)

Une fois le script `start.sh` terminé, ouvrez un nouveau terminal pour lancer le serveur de développement mobile :

```bash
cd frontend
npm start
```
*(Si `npm` n'est pas installé sur votre machine, le script `start.sh` vous donne la commande Podman équivalente pour lancer le serveur Expo !)*

### 3. Comment interagir avec l'IA sur ce projet ?

*   **Frontend** : Demandez à l'IA de créer de nouveaux écrans dans `frontend/app/`.
*   **Backend** : Demandez à l'IA de modifier `backend/src/index.ts` (ou d'ajouter de nouvelles routes).
*   **Base de Données** : Modifiez le fichier Prisma et relancez le backend, la base `database/database.sqlite` se mettra à jour.
