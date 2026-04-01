#!/usr/bin/env bash

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CANVAS_DIR="$PLUGIN_DIR/canvases"
mkdir -p "$CANVAS_DIR"

SESSION_NAME=$(tmux display-message -p '#S')
if [ -z "$SESSION_NAME" ]; then
    tmux display-message "Error: Could not determine session name"
    exit 1
fi

TARGET_FILE="$CANVAS_DIR/${SESSION_NAME}.sh"
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

tmux display-message "Capturing canvas for session: $SESSION_NAME..."

cat <<EOF > "$TARGET_FILE"
#!/usr/bin/env bash
# Canvas: $SESSION_NAME
# Captured on: $CURRENT_DATE
#
# Usage: source this file with SESSION_NAME set, or pass session name as \$1
#   SESSION_NAME=mysession source ${SESSION_NAME}.sh
#   bash ${SESSION_NAME}.sh mysession

if [ -n "\$1" ]; then
    SESSION_NAME="\$1"
fi

if [ -z "\$SESSION_NAME" ]; then
    echo "Error: SESSION_NAME is not set."
    exit 1
fi

EOF

tmux list-windows -t "$SESSION_NAME" -F '#I #W #{window_layout}' | \
while IFS=' ' read -r win_id win_name win_layout; do

    win_layout=$(tmux display-message -p -t "$SESSION_NAME:$win_id" '#{window_layout}')
    win_dir=$(tmux display-message -p -t "$SESSION_NAME:${win_id}.0" '#{pane_current_path}')

    if [ "$win_id" -eq 0 ]; then
        cat <<EOF >> "$TARGET_FILE"
# --- Window 0: $win_name ---
tmux rename-window -t "\$SESSION_NAME:0" "$win_name"
tmux send-keys -t "\$SESSION_NAME:0.0" "cd $win_dir" C-m

EOF
    else
        cat <<EOF >> "$TARGET_FILE"
# --- Window $win_id: $win_name ---
tmux new-window -t "\$SESSION_NAME" -n "$win_name" -c "$win_dir"

EOF
    fi

    pane_count=$(tmux list-panes -t "$SESSION_NAME:$win_id" | wc -l)

    if [ "$pane_count" -gt 1 ]; then
        tmux list-panes -t "$SESSION_NAME:$win_id" \
            -F '#P #{pane_current_path} #{pane_width} #{pane_height} #{pane_at_right} #{pane_at_bottom}' | \
        while read -r pane_id pane_path pane_w pane_h at_right at_bottom; do

            if [ "$pane_id" -eq 0 ]; then
                continue
            fi

           if [ "$at_bottom" -eq 0 ]; then
                split_flag="-v"   
            else
                split_flag="-h"  
            fi

            cat <<EOF >> "$TARGET_FILE"
tmux split-window -t "\$SESSION_NAME:$win_id" $split_flag -c "$pane_path"
EOF
        done

        cat <<EOF >> "$TARGET_FILE"
tmux select-layout -t "\$SESSION_NAME:$win_id" "$win_layout"

EOF
    fi

done

cat <<EOF >> "$TARGET_FILE"
# Return focus to first window, first pane
tmux select-window -t "\$SESSION_NAME:0"
tmux select-pane -t "\$SESSION_NAME:0.0"
EOF

chmod +x "$TARGET_FILE"
tmux display-message "Canvas captured to: $TARGET_FILE"
