#!/usr/bin/env bash

# FIXME: Running an osascript on an application target opens that app
# This sleep is needed to try and ensure that theres enough time to
# quit the app before the next osascript command is called. I assume
# com.apple.iTunes.playerInfo fires off an event when the player quits
# so it imediately runs before the process is killed
sleep 1

APP_STATE=$(pgrep -x Music)
if [[ ! $APP_STATE ]]; then
    sketchybar -m --set music drawing=off
    exit 0
fi

PLAYER_STATE=$(osascript -e "tell application \"Music\" to set playerState to (get player state) as text")
if [[ $PLAYER_STATE == "stopped" ]]; then
    sketchybar --set music drawing=off
    exit 0
fi

TITLE=$(osascript -e 'tell application "Music" to get name of current track')
ARTIST=$(osascript -e 'tell application "Music" to get artist of current track')
# ALBUM=$(osascript -e 'tell application "Music" to get album of current track')
loved=$(osascript -l JavaScript -e "Application('Music').currentTrack().loved()")
if [[ $loved ]]; then
    icon=""
fi

if [[ $PLAYER_STATE == "paused" ]]; then
    icon=""
fi

if [[ $PLAYER_STATE == "playing" ]]; then
    icon=""
fi

if [[ ${#TITLE} -gt 25 ]]; then
    TITLE=${TITLE:0:25}
fi

if [[ ${#ARTIST} -gt 25 ]]; then
    ARTIST=${ARTIST:0:25}
fi

# if [[ ${#ALBUM} -gt 25 ]]; then
#   ALBUM=$(printf "$(echo $ALBUM | cut -c 1-12)…")
# fi

sketchybar -m --set music icon="$icon"          \
    --set music label="${ARTIST}  \"${TITLE}\""   \
    --set music drawing=on
