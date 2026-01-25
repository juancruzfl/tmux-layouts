#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export CANVAS_DIR="$HOME/.tmux-canvases"
mkdir -p "$CANVAS_DIR"

tmux set-hook -g after-new-session "run-shell '$CURRENT_DIR/scripts/session-init.sh #{session_name}'"
