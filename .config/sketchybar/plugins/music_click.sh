#!/usr/bin/env bash

PLAYER_STATE=$(osascript -e "tell application \"Music\" to set playerState to (get player state) as text")
if [[ $PLAYER_STATE != "playing" ]]; then
    osascript -e "tell application \"Music\" to play"
    exit 0
else
    osascript -e "tell application \"Music\" to pause"
    exit 0
fi
