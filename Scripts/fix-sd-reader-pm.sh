#!/bin/bash
#
# Fix per il lettore SD interno (Realtek RTS525A / rtsx_pci) che disconnette
# e riconnette la scheda a intermittenza.
#
# Causa: il runtime power management sospende la scheda e al risveglio
# fallisce la rinegoziazione della tensione UHS-I ("cannot verify signal
# voltage switch" / "error -110 doing runtime resume" in journalctl -k).
#
# Lo script disattiva il runtime PM subito (fix immediato) e installa una
# regola udev che lo rende permanente a ogni riavvio/reinserimento.
#
# Uso: sudo ./fix-sd-reader-pm.sh
#
set -euo pipefail

RULES_FILE=/etc/udev/rules.d/99-sdcard-no-pm.rules

if [ "$(id -u)" -ne 0 ]; then
    echo "Serve root: rilancia con sudo (o pkexec) $0" >&2
    exit 1
fi

echo "== Fix immediato: disattivo il runtime PM sui dispositivi presenti =="

# Chip PCIe del lettore (Realtek 10ec:525a)
for dev in /sys/bus/pci/devices/*; do
    if [ "$(cat "$dev/vendor" 2>/dev/null)" = "0x10ec" ] && \
       [ "$(cat "$dev/device" 2>/dev/null)" = "0x525a" ]; then
        echo on > "$dev/power/control"
        echo "  lettore PCIe: $dev -> on"
    fi
done

# Scheda/e SD attualmente inserite (è questo il device decisivo)
found_card=0
for dev in /sys/bus/mmc/devices/*; do
    if [ -w "$dev/power/control" ]; then
        echo on > "$dev/power/control"
        echo "  scheda: $dev -> on"
        found_card=1
    fi
done
[ "$found_card" -eq 0 ] && echo "  (nessuna scheda SD inserita al momento)"

echo "== Fix permanente: installo la regola udev =="
cat > "$RULES_FILE" <<'EOF'
ACTION=="add", SUBSYSTEM=="mmc", TEST=="power/control", ATTR{power/control}="on"
ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10ec", ATTR{device}=="0x525a", ATTR{power/control}="on"
EOF
udevadm control --reload
echo "  installato $RULES_FILE e ricaricato udev"

echo "== Fatto =="
echo "Per verificare che gli errori siano spariti:"
echo "  journalctl -k -f | grep -i mmc0"
