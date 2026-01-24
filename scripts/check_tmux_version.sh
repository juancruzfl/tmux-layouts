#!/usr/bin/env bash

RAW_VERSION=$(tmux -V | cut -d' ' -f2)
MIN_VERSION="2"

get_tmux_version() {
    echo "$1" | sed 's/[^0-9.]*//g' | cut -d. -f1
}
VERSION_INT=$(get_tmux_version "$RAW_VERSION")

if [ "$VERSION_INT" -lt "$MIN_VERSION" ]; then
    echo "Error: tmux version $VERSION_INT is not supported. Min version: $MIN_VERSION"
    tmux display-message "Error: tmux version $VERSION_INT is too old!"
    exit 1
fi

echo "Successfully verified tmux version $VERSION_INT."
