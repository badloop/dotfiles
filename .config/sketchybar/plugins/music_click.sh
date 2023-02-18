#!/usr/bin/env bash

OPERATION="play"
PLAYER_STATE=$(osascript -e "tell application \"Music\" to set playerState to (get player state) as text")
if [[ -n $1 ]]; then
    OPERATION="${1}"
fi

if [[ $OPERATION == "play" ]]; then
    if [[ $PLAYER_STATE != "playing" ]]; then
        osascript -e "tell application \"Music\" to play"
        exit 0
    else
        osascript -e "tell application \"Music\" to pause"
        exit 0
    fi
elif [[ $OPERATION == "next" ]]; then
    osascript -e "tell application \"Music\" to play next track"
    exit 0
elif [[ $OPERATION == "prev" ]]; then
    osascript -e "tell application \"Music\" to play previous track"
    exit 0
fi
