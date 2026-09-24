#!/usr/bin/env bash
#
# segoe-to-ubuntu-sans.sh
# Fa in modo che ogni sito/app che chiede "Segoe UI" usi "Ubuntu Sans".
# Alias fontconfig a livello utente (non tocca la configurazione di sistema).
#
# Uso:
#   ./segoe-to-ubuntu-sans.sh            # installa l'alias
#   ./segoe-to-ubuntu-sans.sh --remove   # rimuove l'alias
#
# NOTA sugli snap: le app snap (Firefox, Chromium, Thunderbird...) girano
# confinate con HOME=~/snap/<app>/current, quindi fontconfig NON legge
# ~/.config/fontconfig ma ~/snap/<app>/current/.config/fontconfig.
# Lo script installa l'alias anche li'. Il fonts.conf dentro lo snap e'
# rigenerato a ogni avvio dal launcher, ma fa <include>conf.d</include>
# relativo: scriviamo li' dentro, cosi' non viene sovrascritto.
#
# Dopo install/remove: riavvia completamente il browser (per gli snap
# chiudi TUTTE le finestre) perche' rilegga la cache dei font.

set -euo pipefail

TARGET_FONT="Ubuntu Sans"
SOURCE_FONT="Segoe UI"
CONF_NAME="99-segoe-to-ubuntu-sans.conf"

# Percorso "normale" (app native/deb, es. Google Chrome)
HOST_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/fontconfig/conf.d"

# Snap che vale la pena coprire, se presenti
SNAP_APPS=(firefox chromium thunderbird)

# Elenca tutte le conf.d di destinazione
target_dirs() {
  echo "$HOST_CONF_DIR"
  for app in "${SNAP_APPS[@]}"; do
    d="$HOME/snap/$app/current/.config/fontconfig"
    [ -d "$d" ] && echo "$d/conf.d"
  done
}

write_conf() {
  cat > "$1" <<EOF
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Ogni pagina/app che chiede "$SOURCE_FONT" ottiene "$TARGET_FONT" -->
  <match target="pattern">
    <test name="family" compare="eq" ignore-blanks="true">
      <string>$SOURCE_FONT</string>
    </test>
    <edit name="family" mode="prepend" binding="strong">
      <string>$TARGET_FONT</string>
    </edit>
  </match>
</fontconfig>
EOF
}

clear_snap_caches() {
  for app in "${SNAP_APPS[@]}"; do
    rm -rf "$HOME/snap/$app/current/.cache/fontconfig" 2>/dev/null || true
  done
}

remove() {
  local found=0 dir
  while read -r dir; do
    [ -z "$dir" ] && continue
    if [ -f "$dir/$CONF_NAME" ]; then
      rm -f "$dir/$CONF_NAME"
      echo "  rimosso: $dir/$CONF_NAME"
      found=1
    fi
  done < <(target_dirs)

  clear_snap_caches
  fc-cache -f >/dev/null 2>&1 || true
  [ "$found" -eq 0 ] && echo "  nessun alias da rimuovere."
  echo "Verifica (host): '$SOURCE_FONT' -> $(fc-match "$SOURCE_FONT")"
}

install() {
  local dir
  # NB: niente 'grep -q' in pipeline: uscirebbe subito, SIGPIPE a monte e
  # con 'set -o pipefail' il test fallirebbe anche a font presente.
  local families
  families=$(fc-list : family | tr ',' '\n' | sed 's/^ *//; s/ *$//' | sort -u)
  if ! printf '%s\n' "$families" | grep -ix "$TARGET_FONT" >/dev/null; then
    echo "ERRORE: il font \"$TARGET_FONT\" non risulta installato." >&2
    echo "Installalo prima di procedere (es. pacchetto fonts-ubuntu)." >&2
    exit 1
  fi

  while read -r dir; do
    [ -z "$dir" ] && continue
    mkdir -p "$dir"
    write_conf "$dir/$CONF_NAME"
    echo "  installato: $dir/$CONF_NAME"
  done < <(target_dirs)

  # invalida la cache font degli snap, altrimenti puo' restare il vecchio match
  clear_snap_caches
  fc-cache -f >/dev/null 2>&1 || true
  echo "Verifica (host): '$SOURCE_FONT' -> $(fc-match "$SOURCE_FONT")"
  echo "Riavvia i browser (snap: chiudi TUTTE le finestre) per applicare."
}

case "${1:-}" in
  --remove|-r|remove|uninstall)
    echo "Rimozione alias..."; remove ;;
  ""|--install|-i|install)
    echo "Installazione alias '$SOURCE_FONT' -> '$TARGET_FONT'..."; install ;;
  *)
    echo "Uso: $0 [--install|--remove]" >&2; exit 2 ;;
esac
