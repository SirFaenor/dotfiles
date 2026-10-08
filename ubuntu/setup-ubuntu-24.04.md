### recap

## monitor 4k casa
- monitor esterno 200%
- monitor interno 100%
- text scaling 0.9
- icone dock 35
- phpstorm zoom 100% / font size UI 14px / font size editor Cascadia Code 15px

## monitor ufficio
- monitor esterno 100%
- monitor interno 100%
- text scaling 1.25
- icone dock 44
- phpstorm: zoom 128% / font size UI 14px / font size editor Cascadia Code 16px

--- OPPURE ---

- monitor esterno 125%
- monitor interno 125%
- text scaling 1
- icone dock 36
- phpstorm: zoom 110% / font size UI 14px / font size editor Cascadia Code 16px

# setup tastiera drevo tyrfing v2
https://github.com/cobacdavid/dtv2
./.local/bin/dtv2change -a -kbd red -cat letters blue function red digits green kpnum green edition purple other red arrows green kpsymbols yellow mod yellow -key space blue enter yellow tab yellow caps yellow

# blurry phpstorm con fractional scaling
https://youtrack.jetbrains.com/issue/IJPL-146619/Blurry-fonts-on-Wayland-fractional-scaling


# wifi after suspend
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2037560

# applicazioni su spazi di lavoro
https://extensions.gnome.org/extension/16/auto-move-windows/


# obsidian
copia snap e poi personalizza
https://askubuntu.com/questions/1026378/how-do-i-add-start-parameter-to-a-program-installed-via-snap

obsidian --no-sandbox --ozone-platform=wayland --ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations %U


# clipboard history
https://extensions.gnome.org/extension/4839/clipboard-history/

# blurry 
chromium --enable-features=UseOzonePlatform --ozone-platform=wayland
Exec=/usr/bin/microsoft-edge-stable --enable-features=UseOzonePlatform --ozone-platform=wayland (in .desktop file in ~/.local/share/applications

# spatie ray
./Ray-2.8.1.AppImage --enable-features=UseOzonePlatfo,WaylandWindowDecorations --ozone-platform=wayland --no-sandbox

# alt+tab, mostra applicazioni solo da spazio di lavoro corrente
gsettings set org.gnome.shell.window-switcher current-workspace-only true


# imposta dimensioni icone dock
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 36

# text scaling factor (0.9 per 4k, 1.25 per altri)
gsettings set org.gnome.desktop.interface text-scaling-factor 0.9

# imposta background opacità dock
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.2

# imposta font
gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'

# lista estensioni / utilities

https://extensions.gnome.org/extension/4839/clipboard-history/
https://extensions.gnome.org/extension/5278/pano/


# scorciatoie
crtl-alt-k applica colori tastiera
ctrl-alt-x strumento gesione appunti


# vscode
https://github.com/microsoft/vscode/issues/207033
https://github.com/electron/electron/issues/44607


# impostaizoni monitor non presistenti
https://github.com/pop-os/pop/issues/226
sudo cp ~/.config/monitors.xml ~/.config/gdm

# phpstorm
- impostazione zoom
/home/{user}/.config/JetBrains/PhpStorm2024.3/options/others.xml chiave "ideScale"
- accelerare rendering testo
editor.zero.latency.typing=true (help > edit  Custom properties) 


# font non visibili su electron
https://askubuntu.com/questions/1224125/font-characters-displayed-as-squares-in-ubuntu-18-04
```
fc-cache -r
rm ~/.cache/fontconfig/*
sudo rm -f /var/cache/fontconfig/*
```
https://github.com/IsmaelMartinez/teams-for-linux/issues/1105#issuecomment-1947728319

# ventole
https://github.com/YoyPa/isw?tab=readme-ov-file

# timeout login
il file /etc/fprintd.conf con timeout = 5 sotto [main] riduce il tempo che fprintd aspetta un'impronta prima di cedere il passo all'autenticazione con password — eliminando il lungo blocco allo sblocco schermo 
sudo nano /etc/fprintd.conf

```
[main]
timeout = 5
```

`sudo systemctl restart fprintd`


## galaxy buds: slider volume non funziona (solo mute)

sintomo: lo slider di sistema (GNOME/PipeWire) sposta il volume dei Galaxy Buds solo verso il minimo/mute, ma non ha effetto sul resto della barra.

causa: WirePlumber registra di default un "dummy AVRCP player" che instrada il volume via AVRCP Bluetooth invece che software; su alcuni device (Galaxy Buds) gli incrementi via AVRCP vengono ignorati.

fix: creare `~/.config/wireplumber/bluetooth.lua.d/51-disable-avrcp-volume.lua` con:
```lua
bluez_monitor.properties["bluez5.dummy-avrcp-player"] = false
```
poi `systemctl --user restart wireplumber` (i buds si riconnettono da soli in pochi secondi).

nota: se in futuro i controlli play/pause/next da Bluetooth smettono di funzionare, potrebbe essere un effetto collaterale di questa modifica.


## problema thumbs mancanti nautilus

https://bugs.launchpad.net/ubuntu/+source/nautilus/+bug/2148075


1. Relax the security restriction (immediate fix): Open your terminal and run: sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0

2. Clear the "failed" thumbnail cache: This forces Nautilus to retry generating thumbnails for files that previously failed: rm -rf ~/.cache/thumbnails/fail/*

3. Restart the file manager: Close all Nautilus instances to apply the changes: nautilus -q

## firefox gnome theme

https://github.com/rafaelmardojai/firefox-gnome-theme