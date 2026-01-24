#!/usr/bin/env bash

declare canvas_name="${1:-default}"

CANVAS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../canvases" && pwd)"
TARGET_CANVAS="$CANVAS_DIR/$canvas_name.sh"

if [ ! -f "$TARGET_CANVAS" ]; then
    tmux display-message "Error: Canvas '$canvas_name' not found in $CANVAS_DIR"
    exit 1
fi

source "$TARGET_CANVAS"
