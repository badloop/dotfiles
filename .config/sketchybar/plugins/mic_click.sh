#!/bin/bash

MIC_VOLUME=$(osascript -e 'input volume of (get volume settings)')

if [[ $MIC_VOLUME -eq 0 ]]; then
    osascript -e 'set volume input volume 35'
    if [[ $? -eq 0 ]]; then
        sketchybar -m --set mic icon=
    fi
elif [[ $MIC_VOLUME -gt 0 ]]; then
    osascript -e 'set volume input volume 0'
    if [[ $? -eq 0 ]]; then
        sketchybar -m --set mic icon=
    fi
fi
