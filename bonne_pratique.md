# Bonnes Pratiques pour le Développement d'Agents IA Autonomes

Le développement d'agents IA autonomes nécessite une approche rigoureuse pour gérer le comportement non-déterministe des modèles de langage (LLM). Ce document détaille les standards architecturaux, de contrôle et d'observabilité essentiels pour construire des systèmes robustes, fiables et prêts pour la production.

---

## 1. Architecture Orientée Composants et Modularité
*   **Fichiers de 100 lignes maximum :** Le code doit être découpé en fonctions et modules courts. La concision force une responsabilité unique par fonction (SRP), ce qui facilite les tests unitaires et la lisibilité.
*   **Réutilisabilité maximale :** Chaque composant (outils, prompts, logique de contrôle) doit être conçu pour être agnostique au cas d'usage spécifique afin de pouvoir être réutilisé dans différents workflows agentiques.
*   **Documentation par dossier :** Chaque répertoire logique doit contenir un fichier `README.md` (ou équivalent) expliquant son rôle, les dépendances de ses composants et comment les instancier.
*   **Code systématiquement commenté :** Les fonctions complexes, en particulier celles gérant les appels au LLM ou le traitement des données asynchrones, doivent inclure des docstrings claires expliquant les paramètres, les retours attendus et le but de la fonction.

## 2. Sécurité et Contrôle d'Exécution (Agent Loop)
La boucle d'exécution (Agent Loop) est le cœur de l'agent. Sans garde-fous, un agent peut s'enfermer dans des cycles coûteux ou destructeurs.

*   **Limites de boucles (Max Iterations) :** C'est le contrôle de sécurité le plus critique. Un agent confronté à une erreur peut s'entêter et tourner en boucle infinie (ex: utiliser un outil, échouer, réessayer exactement la même chose 50 fois). Vous devez définir un nombre maximum d'étapes (steps) ou de tours (turns) par tâche pour couper le processus (ex: `max_iterations = 10`).
*   **Timeouts stricts :** Fixez des limites de temps globales pour la tâche (wall-clock timeout) et des limites spécifiques pour chaque appel d'outil ou d'API. Si un outil dépasse le délai, l'agent doit recevoir une erreur explicite plutôt que de rester bloqué.
*   **Idempotence des actions :** Puisque l'agent risque d'appeler le même outil plusieurs fois par erreur ou lors de retries, vos fonctions doivent être exécutables en boucle sans casser le système ni dupliquer des données. 
    *   *Exemple :* Utilisez des requêtes de mise à jour/upsert au lieu de simples insertions. Vérifiez l'état du système (ex: "ce fichier existe-t-il déjà ?") avant d'exécuter une action.

## 3. Gestion des Erreurs et Robustesse
*   **Messages informatifs clairs :** Les erreurs, les états de chargement (loading) et les succès doivent générer des messages clairs et structurés. Ces messages ne sont pas seulement pour l'utilisateur, ils sont aussi le *feedback* que l'agent lit pour corriger son comportement.
*   **Contrôles d'exceptions granulaires :** Les fonctions doivent utiliser des blocs `try/catch` spécifiques. Si une API externe échoue, l'erreur renvoyée à l'agent doit être suffisamment descriptive pour qu'il comprenne *pourquoi* (ex: "Erreur 404 : L'utilisateur n'existe pas" au lieu de "Erreur système").
*   **Gestion de la mémoire et du contexte :** Le code doit inclure une stratégie pour tronquer ou résumer l'historique des actions afin d'éviter de saturer la fenêtre de contexte du modèle (Token limits) au fil des itérations.

## 4. Portabilité et Conteneurisation (Dossier Autonome)
L'environnement de travail doit être pensé comme un **dossier portable et complètement autonome**.

*   **Tout-en-un à la racine :** Tout ce qui est nécessaire pour exécuter le projet (code source, scripts de démarrage comme `start.sh`, orchestration Docker/Podman, fichiers de base de données locale) doit se trouver dans ce dossier unique. Aucun composant système global complexe ne doit être requis en dehors des moteurs de conteneurs standards.
*   **Dépendances embarquées :** Privilégier les installations locales de dépendances plutôt que globales, afin de s'assurer qu'un autre développeur (ou un agent IA) puisse cloner le dossier et lancer le projet instantanément sans conflit d'environnement.
*   **Rangement par domaine :** Le dossier de travail doit être rigoureusement organisé (ex: `frontend/`, `backend/`, `database/`) pour qu'une IA ou un humain puisse naviguer et identifier immédiatement où se trouve chaque module du système.

## 5. Synchronisation Documentaire & Suivi de Session
À chaque session de développement, il est **obligatoire** de maintenir à jour les documents de référence :

*   **Mise à jour de `sommaire_architecture.md` :** Doit impérativement être synchronisé avec l'arborescence réelle des fichiers, les nouveaux composants backend/frontend, les schémas Drizzle et les endpoints exposés.
*   **Mise à jour de `avancement_projet.md` :** Doit lister précisément les étapes et sous-fonctionnalités déjà développées ainsi que les étapes restantes à réaliser selon la roadmap du Whitepaper.

## 6. Capitalisation des Erreurs : Document `mauvaise_pratique.md`
Tout développement d'envergure confronte les agents IA à des pièges récurrents (conflits de schémas, cascades destructives, appels API non mis en cache, erreurs silencieuses).

*   **Tenue obligatoire du registre :** Le document [`mauvaise_pratique.md`](file:///home/gamo/Documents/iworker/mauvaise_pratique.md) à la racine recense chaque erreur majeure survenue, sa cause racine, l'anti-pattern à proscrire et la bonne pratique de remédiation adoptée.
*   **Consultation préventive :** Tout agent IA intervenant sur le projet doit consulter ce registre avant d'entamer une refonte ou d'ajouter une brique sensible (authentification, transactions, appels externes, synchronisation hors-ligne).
*   **Enrichissement systématique :** Dès qu'un bogue subtil, un goulet d'étranglement ou une régression est résolu, l'agent doit formaliser le cas dans `mauvaise_pratique.md` pour éviter sa réapparition par d'autres agents.

## 7. Standards d'Excellence UX et UI ("Bon UX et UI")
Tout composant ou interface conçu par un agent IA doit impérativement respecter la charte d'expérience utilisateur détaillée dans [`bon_ux_ui.md`](file:///home/gamo/Documents/iworker/bon_ux_ui.md) :

*   **Priorités spatiales strictes :** Plus un élément est prioritaire pour l'utilisateur, plus il est placé haut, devant et mis en valeur visuellement. Sans même lire, l'utilisateur doit repérer la priorité immédiate et le bouton d'action clé.
*   **Proximité des actions & Boutons "Tag" :**
    *   Boutons d'ajout, modification ou suppression **collés à la valeur cible** (effet repère immédiat).
    *   Format petit tag/pilule discret (`borderRadius: 14` à `20`), jamais d'icône orpheline ou de gros pavé perturbateur.
    *   **Regroupement cohérent :** Actions de modification et de suppression réunies dans la même bulle contextuelle pour économiser l'attention (TDAH-friendly).
*   **Glassmorphisme doux & contrastes nuancés :**
    *   Fond glassmorphe translucide avec bordures subtiles.
    *   Ni blanc pur aveuglant (`#ffffff`), ni noir complet agressif (`#000000`). Nuancer toujours les teintes vers un sombre adouci (ardoise bleutée) ou un clair feutré.
*   **Interface respirante, groupée en Cards (TDAH-friendly) :**
    *   Aérer généreusement avec du padding et des marges.
    *   Grouper impérativement les informations associées dans des **cards visuelles** pour structurer l'espace et apaiser la charge cognitive.
*   **Arrondis systématiques (Zéro angle aigu) :**
    *   Bannir les coins droits qui créent une sensation inconsciente d'insécurité (`borderRadius` systématique de 12px à 24px pour inputs, boutons et cartes).
*   **Formulaires progressifs par bulles contextuelles :**
    *   Bannir les formulaires géants intimidants.
    *   Procéder par itérations progressives : créer la donnée maîtresse en premier, puis enrichir.
    *   Pas de formulaires pré-affichés encombrants : utiliser un bouton d'action placé près de la zone concernée qui ouvre une bulle/modale de complétion ciblée.
    *   **Maximum 2 champs à la fois**, avec des placeholders évocateurs et des labels discrets ou contextuels.
*   **Dissimulation des zones destructives ou marginales :**
    *   Les blocs comme « Supprimer le compte » ne doivent jamais monopoliser l'attention.
    *   Ils doivent être dissimulés par défaut sous un bouton sobre (accordéon contextuel qui s'ouvre sous le bouton).
