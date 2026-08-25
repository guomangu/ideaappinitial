#!/bin/bash

# Arrêter le script en cas d'erreur
set -e

echo "🚀 Démarrage de la Stack AI-Driven..."

# Fonction pour installer un paquet selon l'OS
install_package() {
    local pkg_name=$1
    echo "⚠️ $pkg_name n'est pas installé. Tentative d'installation automatique..."
    if command -v dnf &> /dev/null; then
        sudo dnf install -y "$pkg_name"
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y "$pkg_name"
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm "$pkg_name"
    else
        echo "❌ Impossible d'installer $pkg_name automatiquement. Veuillez l'installer manuellement."
        exit 1
    fi
}

# Vérification des dépendances système (podman, npm, npx)
if ! command -v podman &> /dev/null; then
    install_package podman
fi

if ! command -v npm &> /dev/null || ! command -v npx &> /dev/null; then
    echo "⚠️ npm ou npx n'est pas installé."
    if command -v dnf &> /dev/null; then
        sudo dnf install -y nodejs npm
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y nodejs npm
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm nodejs npm
    else
        echo "❌ Impossible d'installer nodejs et npm automatiquement."
        exit 1
    fi
fi

# Vérifier la présence de podman-compose ou docker-compose
COMPOSE_CMD=""
if command -v podman-compose &> /dev/null; then
    COMPOSE_CMD="podman-compose"
elif command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
else
    install_package podman-compose
    COMPOSE_CMD="podman-compose"
fi

echo "⚙️  Étape 1 : Démarrage du Backend (Hono API)"
# Construit et démarre le conteneur en arrière-plan
$COMPOSE_CMD up -d --build backend
echo "✅ Backend démarré sur http://localhost:3000"

echo "⚙️  Étape 2 : Vérification du Frontend (Expo)"
cd frontend

# Installation des dépendances si node_modules n'existe pas
if [ ! -d "node_modules" ]; then
    echo "⏳ Installation des dépendances Frontend avec npm..."
    npm install
else
    echo "✅ Dépendances Frontend déjà installées."
fi

cd ..

echo ""
echo "🎉 Tout est prêt !"
echo "👉 Backend : Les logs sont consultables via '$COMPOSE_CMD logs -f backend'"
echo "👉 Frontend : Pour démarrer le serveur de développement mobile (Expo), lancez :"
echo "   cd frontend"
echo "   npm start"
