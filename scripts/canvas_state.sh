#!/usr/bin/env bash

CANVAS_DIR="$HOME/.tmux-canvases"
mkdir -p "$CANVAS_DIR"

SESSION_NAME=$(tmux display-message -p '#S')
TARGET_FILE="$CANVAS_DIR/${SESSION_NAME}.sh"

echo "Saving state for session: $SESSION_NAME..."

cat <<EOF > "$TARGET_FILE"
#!/usr/bin/env bash
# Auto-generated Canvas for: $SESSION_NAME
# Generated on: $(date)

EOF

tmux list-windows -t "$SESSION_NAME" -F '#I #W' | while read -r win_id win_name; do
    if [ "$win_id" -ne 0 ]; then
        echo "tmux new-window -t \"$SESSION_NAME\" -n \"$win_name\"" >> "$TARGET_FILE"
    else
        echo "tmux rename-window -t \"$SESSION_NAME:0\" \"$win_name\"" >> "$TARGET_FILE"
    fi
    
    tmux list-panes -t "$SESSION_NAME:$win_id" -F '#P #{pane_current_path}' | while read -r pane_id pane_path; do
        if [ "$pane_id" -ne 0 ]; then
            echo "tmux split-window -t \"$SESSION_NAME:$win_id\" -c \"$pane_path\"" >> "$TARGET_FILE"
            echo "tmux select-layout -t \"$SESSION_NAME:$win_id\" tiled" >> "$TARGET_FILE"
        fi
    done
done

chmod +x "$TARGET_FILE"
tmux display-message "Canvas saved to $TARGET_FILE"
