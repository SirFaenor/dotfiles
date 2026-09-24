#!/bin/bash

#  will take first argument as path for finding the wallpaper
path=$1;

#  if path is not provided set some default directory for images
if ["$path" = ""]; then
        #  default path can be any valid directory
        #  to use ubuntu provided wallpapers
        #  /usr/share/backgrounds/
        path="/home/manu/Immagini/Sfondi/"
fi

#  find $path -name '*' -exec file {} \; -> get all the file details in the directory
#  grep -o -P '^.+image.+$' -> get all the valid images
#  grep -o -P '^.+\..+:' -> get the file path
#  sed 's/.$//' -> remove the extra ':'
images=$(find $path -name '*' -exec file {} \; | grep -o -P '^.+image.+$' | grep -o -P '^.+\..+:' | sed 's/.$//')

#  start the infinite loop
while true; do
        #  traverse all the images
        for image in $images; do
        	#  the command to set the wallpaper for light theme
                $(gsettings set org.gnome.desktop.background picture-uri \'file://$image\')
                #  the command to set the wallpaper for dark theme
                $(gsettings set org.gnome.desktop.background picture-uri-dark \'file://$image\')
                #  add a x seconds delay
                #  delay could also be taken from arguments just like path
                sleep 600
        done
done
