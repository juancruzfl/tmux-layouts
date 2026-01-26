#!/usr/bin/env bash

export SESSION_NAME="$1"
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PREDEFINED_CANVASES="$PLUGIN_DIR/canvases"

if [ -f "$PREDEFINED_CANVASES/${SESSION_NAME}.sh" ]; then
    tmux display-message "Loading canvas: $SESSION_NAME"
    source "$PREDEFINED_CANVASES/${SESSION_NAME}.sh"
else
    :
fi
