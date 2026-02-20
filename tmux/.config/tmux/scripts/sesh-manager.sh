#!/usr/bin/env bash
# sesh-manager.sh - Session manager popup with new project support
# Called from tmux keybinding (Ctrl+F)

SESH="$HOME/go/bin/sesh"
NEWP="$HOME/.config/tmux/scripts/newp.sh"

selected=$("$SESH" list -tz | fzf-tmux -p 55%,60% \
    --no-sort --border-label ' TMUX Session Manager ' --prompt '⚡  ' \
    --header '  ^a all ^t tmux ^x zoxide ^f find ^n new' \
    --bind 'tab:down,btab:up' \
    --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list)' \
    --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t)' \
    --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z)' \
    --bind "ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)" \
    --bind "ctrl-n:become($NEWP --interactive)")

# If fzf returned a selection (normal mode), connect via sesh
if [ -n "$selected" ]; then
    "$SESH" connect "$selected"
fi
