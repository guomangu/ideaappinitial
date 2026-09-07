#!/usr/bin/env bash
# ==============================================================================
# iWorker — Script relais racine pour le lancement unifié
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export npm_config_include="dev"
exec "$SCRIPT_DIR/ideaappinitial/start.sh" "$@"
