#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CANVAS_DIR="$CURRENT_DIR/canvases"
mkdir -p "$CANVAS_DIR"

export CANVAS_DIR

tmux set-hook -g after-new-session "run-shell 'bash $CURRENT_DIR/scripts/session-init.sh #{session_name}'"

tmux bind-key S run-shell "bash '$CURRENT_DIR/scripts/canvas-state.sh'"
