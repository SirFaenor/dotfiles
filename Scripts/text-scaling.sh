#!/bin/bash

# Get Current Scailing factor
SCALE=$(gsettings get org.gnome.desktop.interface text-scaling-factor)

if [ $SCALE == '1.25' ]; then
    # home
    SCALE_SWITCH=1
    ICONS_SIZE=35
else
    #office
    SCALE_SWITCH=1.25
    ICONS_SIZE=44
fi

# (Optional) Message intentions to CLI and GNOME Notifications
echo -e "Previous Font Scale: $SCALE, Switched to $SCALE_SWITCH"
notify-send "Previous Font Scale: $SCALE, Switched to $SCALE_SWITCH"

# Run switch command
gsettings set org.gnome.desktop.interface text-scaling-factor $SCALE_SWITCH
#gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size $ICONS_SIZE
