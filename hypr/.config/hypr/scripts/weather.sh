#!/usr/bin/env bash
#
WEATHER_CONFIG="$HOME/.local/share/weather/config"
if [[ ! -f "$WEATHER_CONFIG" ]]; then
	echo "ERR: no config"
	echo "Create $WEATHER_CONFIG with:" >&2
	echo "  STATION=<station_id>  # e.g. KEVV (NWS observation station)" >&2
	echo "  Find yours: https://www.weather.gov/media/documentation/docs/current_stationlist.txt" >&2
	exit 1
fi
source "$WEATHER_CONFIG"
if [[ -z "$STATION" ]]; then
	echo "ERR: no STATION"
	echo "Add STATION=<id> to $WEATHER_CONFIG" >&2
	exit 1
fi

C=$(curl -s "https://api.weather.gov/stations/${STATION}/observations/latest" | jq '.properties.temperature.value')
temp=$(echo "($C*1.8)+32" | bc | awk -F. '{print $1}')
conditions=$(curl -s "https://api.weather.gov/stations/${STATION}/observations/latest" | jq '.properties.textDescription')
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
	if ((hour >= 20)) || ((hour < 6)); then
		icon="󰖔"
	elif ((hour >= 6)) && ((hour < 8)); then
		icon=""
	elif ((hour >= 17)) && ((hour < 20)); then
		icon=""
	fi
	;;
esac
echo "${icon} ${temp}°"
