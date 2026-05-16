#!/usr/bin/env bash

export SESSION_NAME="$1"
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PREDEFINED_LAYOUTS="$PLUGIN_DIR/layouts"

if [ -f "$PREDEFINED_LAYOUTS/${SESSION_NAME}.sh" ]; then
    tmux display-message "Loading layout: $SESSION_NAME"
    source "$PREDEFINED_LAYOUTS/${SESSION_NAME}.sh"
else
    :
fi
