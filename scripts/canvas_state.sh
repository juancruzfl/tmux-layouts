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

tmux display-message "Saving canvas for session: $SESSION_NAME..."

CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

FIRST_PANE_DIR=$(tmux display-message -p -t "$SESSION_NAME:0.0" '#{pane_current_path}')

cat <<EOF > "$TARGET_FILE"
#!/usr/bin/env bash
# Canvas: $SESSION_NAME
# Saved on: $CURRENT_DATE

PROJECT_DIR="$FIRST_PANE_DIR"

# Set directory for first pane
tmux send-keys -t "\$SESSION_NAME:0" "cd \$PROJECT_DIR" C-m
sleep 0.3

EOF

tmux list-windows -t "$SESSION_NAME" -F '#I #W' | while read -r win_id win_name; do
    win_dir=$(tmux display-message -p -t "$SESSION_NAME:$win_id.0" '#{pane_current_path}')
    
    if [ "$win_id" -eq 0 ]; then
        echo "tmux rename-window -t \"\$SESSION_NAME:0\" \"$win_name\"" >> "$TARGET_FILE"
    else
        echo "tmux new-window -t \"\$SESSION_NAME\" -n \"$win_name\" -c \"$win_dir\"" >> "$TARGET_FILE"
    fi
    
    tmux list-panes -t "$SESSION_NAME:$win_id" -F '#P #{pane_current_path}' | while read -r pane_id pane_path; do
        if [ "$pane_id" -ne 0 ]; then
            echo "tmux split-window -t \"\$SESSION_NAME:$win_id\" -c \"$pane_path\"" >> "$TARGET_FILE"
            echo "tmux select-layout -t \"\$SESSION_NAME:$win_id\" tiled" >> "$TARGET_FILE"
        fi
    done
done

cat <<EOF >> "$TARGET_FILE"

# Return to first window
tmux select-window -t "\$SESSION_NAME:0"
tmux select-pane -t 0
EOF

chmod +x "$TARGET_FILE"

tmux display-message "Canvas saved to: $TARGET_FILE"
