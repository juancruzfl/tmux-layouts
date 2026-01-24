#!/usr/bin/env bash

TEST_CANVAS_NAME="test-canvas"

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CANVAS_DIR="$TEST_DIR/../canvases/test-layout"
TARGET_CANVAS="$CANVAS_DIR/$TEST_CANVAS_NAME.sh"

if [ -f "$TARGET_CANVAS" ]; then
    echo "Canvas '$TEST_CANVAS_NAME' found at $TARGET_CANVAS"
    exit 0
else
    echo "FAIL: Canvas '$TEST_CANVAS_NAME' not found at $TARGET_CANVAS"
    exit 1
fi
