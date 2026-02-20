#!/bin/zsh
sed -i -E '/(active|inactive|fullscreen)_opacity = (\.8|1)/ {s/\.8/1/;t;s/1/.8/}' ~/.config/hypr/hyprland.conf
