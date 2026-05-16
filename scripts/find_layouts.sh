#!/usr/bin/env bash

declare layout_name="${1:-default}"

LAYOUT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../layouts" && pwd)"
TARGET_LAYOUT="$LAYOUT_DIR/$layout_name.sh"

if [ ! -f "$TARGET_LAYOUT" ]; then
    tmux display-message "Error: Layout '$layout_name' not found in $LAYOUT_DIR"
    exit 1
fi

source "$TARGET_LAYOUT"
