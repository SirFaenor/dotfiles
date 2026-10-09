#!/bin/bash


SCHEMA="org.gnome.desktop.interface"
KEY="color-scheme"
CURRENT=$(gsettings get $SCHEMA $KEY)

wallpaper_schemaDir="/home/sirfaenor/.local/share/gnome-shell/extensions/azwallpaper@azwallpaper.gitlab.com/schemas"
wallpaper_schema="org.gnome.shell.extensions.azwallpaper"
wallpaper_key="slideshow-directory"

panel_extension="panel-color@sirfaenor"
panel_stylesheet="/home/sirfaenor/.local/share/gnome-shell/extensions/${panel_extension}/stylesheet.css"


if [[ "$CURRENT" == "'prefer-dark'" ]]; then
    # passaggio a light
    gsettings set $SCHEMA $KEY 'default'
    wallpaper_value="prefer-light"
    icon_theme="Yaru-blue" #kora-grey|Conflux
    accent_color="Yaru-blue"
    bar_rgb="0,0,0" # #0317fc (top bar + dock)
    bar_opacity="0.6"
    bar_fg="#FFFFFF" # testo e icone della top bar
else
    # passaggio a dark
    gsettings set $SCHEMA $KEY 'prefer-dark'
    wallpaper_value="prefer-dark"
    icon_theme="Yaru-blue" #kora-grey|Conflux
    accent_color="Yaru-blue"
    bar_rgb="0,0,0" # #0317fc (top bar + dock)
    bar_opacity="0.6"
    bar_fg="#FFFFFF" # testo e icone della top bar
fi

# force directory overwriting decision above (uncomment to make it live)
#wallpaper_value="batman"

# set accent color
gsettings set org.gnome.desktop.interface gtk-theme ${accent_color}

# force icon theme
gsettings set org.gnome.desktop.interface icon-theme ${icon_theme}

# set top bar background (riscrive lo stylesheet dell'estensione panel-color e la ricarica)
cat > "${panel_stylesheet}" <<EOF
#panel {
  background-color: rgba(${bar_rgb}, ${bar_opacity});
}
#panel .panel-button {
  color: ${bar_fg};
}
EOF
gnome-extensions disable ${panel_extension}
gnome-extensions enable ${panel_extension}

# set dock background (ubuntu-dock, stesso colore e opacità della top bar)
gsettings set org.gnome.shell.extensions.dash-to-dock custom-background-color true
gsettings set org.gnome.shell.extensions.dash-to-dock background-color "rgb(${bar_rgb// /})"
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity ${bar_opacity}

# change wallapers directory (azwallpaper slideshow)
gsettings --schemadir ${wallpaper_schemaDir} set ${wallpaper_schema} ${wallpaper_key} "/home/sirfaenor/Nextcloud/Immagini/Sfondi/favs/${wallpaper_value}"

# change wallpapers directory (variety)
#variety -q
#variety --set-option favorites_folder "/home/sirfaenor/Nextcloud/Immagini/Sfondi/favs/${wallpaper_value}"
#variety

# per recuperare lista chiavi estensioni slideshow wallpaper
# gsettings --schemadir /home/sirfaenor/.local/share/gnome-shell/extensions/azwallpaper@azwallpaper.gitlab.com/schemas list-recursively org.gnome.shell.extensions.azwallpaper



