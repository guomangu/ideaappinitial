#!/usr/bin/env bash
# ==============================================================================
# Script racine pour le lancement unifié de l'Universal Stack (AI-Native)
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==========================================================="
echo "🚀 Démarrage de The Universal Stack"
echo "==========================================================="

# Vérification du fichier d'environnement
if [ ! -f "$SCRIPT_DIR/.env" ]; then
    echo "📄 Création du fichier .env à partir de .env.example..."
    cp "$SCRIPT_DIR/.env.example" "$SCRIPT_DIR/.env"
    echo "⚠️ Le fichier .env a été créé avec les valeurs par défaut."
fi

# Exporter les variables du .env pour les rendre disponibles au script
if [ -f "$SCRIPT_DIR/.env" ]; then
    export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs)
fi

echo "🐳 Lancement de l'infrastructure (Base de données et Backend via Docker)..."
cd "$SCRIPT_DIR"
docker compose up --build -d

echo ""
echo "📦 Préparation du Frontend (React Native & Expo)..."
cd "$SCRIPT_DIR/frontend"

# Le frontend d'Expo peut avoir besoin du .env du niveau supérieur, 
# on peut aussi faire un lien symbolique ou le copier
if [ ! -f ".env" ]; then
    ln -s ../.env .env
fi

# Installation des dépendances si non présentes
if [ ! -d "node_modules" ]; then
    echo "⚙️ Installation des dépendances NPM pour le frontend..."
    npm install
fi

echo ""
echo "📱 Lancement de l'environnement de développement frontend..."
echo "(Appuyez sur 'w' pour le Web, 'i' pour iOS, 'a' pour Android)"
echo "-----------------------------------------------------------"
# Utilisation du port spécifié dans .env, par défaut 8081
EXPO_PORT=${PORT:-8081}
export PORT=$EXPO_PORT

exec npx expo start -c --port $EXPO_PORT
