#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LAYOUT_DIR="$CURRENT_DIR/layouts"
mkdir -p "$LAYOUT_DIR"

export LAYOUT_DIR

tmux set-hook -g after-new-session "run-shell 'bash $CURRENT_DIR/scripts/session_init.sh #{session_name}'"

tmux bind-key S run-shell "bash '$CURRENT_DIR/scripts/capture_layout.sh'"
