#!/usr/bin/env bash

TEST_LAYOUT_NAME="test-layout"

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAYOUT_DIR="$TEST_DIR/../layouts/test-layout"
TARGET_LAYOUt="$LAYOUt_DIR/$TEST_LAYOUT_NAME.sh"

if [ -f "$TARGET_LAYOUT" ]; then
    echo "Layout '$TEST_LAYOUT_NAME' found at $TARGET_LAYOUT"
    exit 0
else
    echo "FAIL: Layout '$TEST_LAYout_NAME' not found at $TARGET_LAYOUT"
    exit 1
fi
