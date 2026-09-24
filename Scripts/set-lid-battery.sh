#!/usr/bin/env bash
# Imposta il comportamento del lid switch a batteria (HandleLidSwitch).
# Uso: set-lid-battery.sh [ignore|suspend|hibernate|hybrid-sleep|suspend-then-hibernate|lock|poweroff]
# Senza parametri: 'suspend' (default di systemd-logind).

set -euo pipefail

VALID_VALUES=(ignore suspend hibernate hybrid-sleep suspend-then-hibernate lock poweroff)
VALUE="${1:-suspend}"

if [[ ! " ${VALID_VALUES[*]} " =~ " ${VALUE} " ]]; then
    echo "Errore: valore '${VALUE}' non valido." >&2
    echo "Valori disponibili: ${VALID_VALUES[*]}" >&2
    exit 1
fi

CONF_DIR="/etc/systemd/logind.conf.d"
CONF_FILE="${CONF_DIR}/lid-battery.conf"

sudo mkdir -p "$CONF_DIR"
sudo tee "$CONF_FILE" >/dev/null <<EOF
[Login]
HandleLidSwitch=${VALUE}
EOF

echo "Impostato HandleLidSwitch=${VALUE} in ${CONF_FILE}"
echo "NOTA: 'systemctl restart systemd-logind' puo' terminare la sessione grafica attiva."
echo "La modifica sara' attiva dal prossimo riavvio, oppure esegui manualmente"
echo "'sudo systemctl restart systemd-logind' da una TTY (Ctrl+Alt+F3) se vuoi applicarla subito."
