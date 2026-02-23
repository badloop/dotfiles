#!/usr/bin/env bash
# Toggle an EWW popup. Closes any other open popup first.
# Usage: popup-toggle.sh <popup-name>
# Example: popup-toggle.sh weather-popup

POPUP="$1"
if [[ -z "$POPUP" ]]; then
    echo "Usage: popup-toggle.sh <popup-name>" >&2
    exit 1
fi

# All known popups
ALL_POPUPS=(github-status-popup github-changelog-popup weather-popup)

# Detect the focused monitor index (Hyprland)
MONITOR=$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused==true) | .id' 2>/dev/null)

# Check if the target popup is currently open
active_windows=$(eww active-windows 2>/dev/null)

if echo "$active_windows" | grep -q "^${POPUP}:"; then
    # Popup is open — close it
    eww close "$POPUP" 2>/dev/null
else
    # Close any other open popups first
    close_list=()
    for p in "${ALL_POPUPS[@]}"; do
        if echo "$active_windows" | grep -q "^${p}:"; then
            close_list+=("$p")
        fi
    done
    if [[ ${#close_list[@]} -gt 0 ]]; then
        eww close "${close_list[@]}" 2>/dev/null
    fi

    # Open the requested popup on the focused monitor
    if [[ -n "$MONITOR" ]]; then
        eww open "$POPUP" --screen "$MONITOR" 2>/dev/null
    else
        eww open "$POPUP" 2>/dev/null
    fi
fi
