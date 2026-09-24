#!/usr/bin/env bash
#
# Backup dei file .vscode/settings e .devcontainer per i progetti dentro
# ~/Progetti/www in ~/Backups/Progetti/vscode_settings, preservando la struttura relativa.
# Usa rsync con --delete: i file rimossi all'origine vengono rimossi anche dalla copia.
#
set -euo pipefail

SRC_ROOT="$HOME/Progetti/www"
DEST_ROOT="$HOME/Backups/Progetti/vscode_settings"

rsync -a --delete \
    --prune-empty-dirs \
    --exclude 'node_modules/' \
    --exclude '.git/' \
    --exclude 'docker/' \
    --exclude 'docker-data/' \
    --include '*/.vscode/settings.json' \
    --include '*/' \
    --include '.devcontainer/' \
    --include '.devcontainer/*' \
    --exclude '.devcontainer/devcontainer-lock.json' \
    --exclude '*' \
    "$SRC_ROOT/" "$DEST_ROOT/"

echo "Backup vscode settings completato."