#!/bin/bash


SCHEMA="org.gnome.desktop.interface"
KEY="color-scheme"
CURRENT=$(gsettings get $SCHEMA $KEY)

wallpaper_schemaDir="/home/sirfaenor/.local/share/gnome-shell/extensions/azwallpaper@azwallpaper.gitlab.com/schemas"
wallpaper_schema="org.gnome.shell.extensions.azwallpaper"
wallpaper_key="slideshow-directory"


if [[ "$CURRENT" == "'prefer-dark'" ]]; then
    # passaggio a light
    gsettings set $SCHEMA $KEY 'default'
    wallpaper_value="prefer-light"
    icon_theme="Conflux" #kora-grey
    accent_color="Yaru-prussiangreen"
else
    # passaggio a dark
    gsettings set $SCHEMA $KEY 'prefer-dark'
    wallpaper_value="prefer-dark"
    icon_theme="Conflux" #kora-grey
    accent_color="Yaru-blue"
fi

# force directory overwriting decision above (uncomment to make it live)
#wallpaper_value="batman"

# set accent color
gsettings set org.gnome.desktop.interface gtk-theme ${accent_color}

# force icon theme
gsettings set org.gnome.desktop.interface icon-theme ${icon_theme}

# change wallapers directory (azwallpaper slideshow)
gsettings --schemadir ${wallpaper_schemaDir} set ${wallpaper_schema} ${wallpaper_key} "/home/sirfaenor/Nextcloud/Immagini/Sfondi/favs/${wallpaper_value}"

# change wallpapers directory (variety)
#variety -q
#variety --set-option favorites_folder "/home/sirfaenor/Nextcloud/Immagini/Sfondi/favs/${wallpaper_value}"
#variety

# per recuperare lista chiavi estensioni slideshow wallpaper
# gsettings --schemadir /home/sirfaenor/.local/share/gnome-shell/extensions/azwallpaper@azwallpaper.gitlab.com/schemas list-recursively org.gnome.shell.extensions.azwallpaper



