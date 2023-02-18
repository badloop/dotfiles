#!/usr/bin/env bash
#
data=$(curl -s -X GET "https://wttr.in/?format=1" | tr -d "+")
icon=$(echo $data | awk '{print $1}')
label=$(echo $data | awk '{print $2}')
echo $icon
echo $label
sketchybar --set $NAME label=$label
sketchybar --set $NAME icon=$icon
