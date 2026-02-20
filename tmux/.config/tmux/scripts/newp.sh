#!/usr/bin/env bash
# newp.sh - Create a new project directory and connect via sesh
#
# Usage:
#   newp.sh <relative-path>        Direct mode: create ~/code/<path> and connect
#   newp.sh --interactive           Interactive mode: launch fzf to pick/type a path
#
# Examples:
#   newp.sh work/my-new-app
#   newp.sh --interactive

set -euo pipefail

BASE="$HOME/code"
SESH="$HOME/go/bin/sesh"

create_and_connect() {
    local input="$1"

    # Strip leading/trailing whitespace
    input="$(echo "$input" | xargs)"

    if [ -z "$input" ]; then
        exit 0
    fi

    local target="$BASE/$input"

    # Create the directory if it doesn't exist
    mkdir -p "$target"

    # Add to zoxide
    zoxide add "$target"

    # Connect via sesh
    "$SESH" connect "$target"
}

if [ "${1:-}" = "--interactive" ]; then
    # Interactive mode: show existing dirs as reference, accept typed query as new path
    # --print-query outputs: line 1 = typed query, line 2 = selected item (if any)
    output=$(fd -d 1 -t d . "$BASE/work" "$BASE/home" 2>/dev/null \
        | sed "s|^$BASE/||" \
        | fzf --print-query \
            --prompt '🆕 ~/code/' \
            --border-label ' New Project ' \
            --header 'Type a new path under ~/code/' \
        || true)

    # Prefer selected item (line 2); fall back to typed query (line 1)
    query=$(echo "$output" | sed -n '1p')
    selected=$(echo "$output" | sed -n '2p')
    input="${selected:-$query}"

    create_and_connect "$input"
else
    create_and_connect "${1:-}"
fi
