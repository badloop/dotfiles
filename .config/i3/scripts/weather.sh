#!/usr/bin/env bash
#
C=$(curl -s https://api.weather.gov/stations/KEVV/observations/latest | jq '.properties.temperature.value')
temp=$(echo "($C*1.8)+32" | bc | awk -F. '{print $1}')
conditions=$(curl -s https://api.weather.gov/stations/KEVV/observations/latest | jq '.properties.textDescription')
icon=""
case "${conditions}" in
    *Partly*Cloudy*)
        # icon=""
        icon=""
        ;;
    *Mostly*Cloudy*)
        icon=""
        ;;
    *Cloudy*)
        icon=""
        ;;
    *Overcast*)
        icon=""
        ;;
    *Snow*)
        icon="󰼶"
        ;;
    *Freezing*Rain*)
        icon=""
        ;;
    *Ice*)
        icon=""
        ;;
    *Light*Rain*)
        icon=""
        ;;
    *Heavy*Rain*)
        icon="󰖖"
        ;;
    *Rain*)
        icon="󰖖"
        ;;
    *Showers*)
        icon=""
        ;;
    *Thunderstorm*)
        icon=""
        ;;
    *Funnel*)
        icon="󰼸"
        ;;
    *Tornado*)
        icon="󰼸"
        ;;
    *Windy*)
        icon="󰖝"
        ;;
    *Hot*)
        icon=""
        ;;
    *Blizzard*)
        icon="󰼶"
        ;;
    *Fog*)
        icon="󰖑"
        ;;
    *)
        hour=$(date '+%H')
        if (( hour >= 20 )) || (( hour < 6 )); then
            icon="󰖔"
        elif (( hour >=6 )) && (( hour < 8 )); then
            icon=""
        elif (( hour >=17 )) && (( hour < 20 )); then
            icon=""
        fi
        ;;
esac
echo "${icon}  ${temp}"
