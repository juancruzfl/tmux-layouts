#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export CANVAS_DIR="$HOME/.tmux-canvases"
mkdir -p "$CANVAS_DIR"

tmux set-hook -g after-new-session "run-shell 'bash $CURRENT_DIR/scripts/session-init.sh #{session_name}'"

tmux bind-key S run-shell "bash '$CURRENT_DIR/scripts/canvas-state.sh'"
