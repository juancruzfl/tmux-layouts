#!/usr/bin/env bash

SESSION_NAME="$1"
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CANVAS_DIR="$HOME/.tmux-canvases"
PREDEFINED_CANVASES="$PLUGIN_DIR/canvases"

if [ -f "$PREDEFINED_CANVASES/${SESSION_NAME}.sh" ]; then
    tmux display-message "Loading predefined canvas: $SESSION_NAME"
    source "$PREDEFINED_CANVASES/${SESSION_NAME}.sh"
elif [ -f "$CANVAS_DIR/${SESSION_NAME}.sh" ]; then
    tmux display-message "Loading saved canvas: $SESSION_NAME"
    source "$CANVAS_DIR/${SESSION_NAME}.sh"
else
    tmux display-message "Creating new canvas: $SESSION_NAME"
    bash "$PLUGIN_DIR/scripts/create_canvas.sh" "$SESSION_NAME"
fi
