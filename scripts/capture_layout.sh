#!/usr/bin/env bash

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LAYOUT_DIR="$PLUGIN_DIR/layouts"
mkdir -p "$LAYOUT_DIR"

SESSION_NAME=$(tmux display-message -p '#S')
if [ -z "$SESSION_NAME" ]; then
    tmux display-message "Error: Could not determine session name"
    exit 1
fi

CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')
TARGET_FILE="$LAYOUT_DIR/${SESSION_NAME}.sh"

tmux display-message "Saving layout for this session: $SESSION_NAME"

first_win_id=$(tmux list-windows -t "$SESSION_NAME" -F '#I' | head -1)

cat > "$TARGET_FILE" <<EOF
#!/usr/bin/env bash
# Layout $SESSION_NAME
# Saved on: $CURRENT_DATE
EOF

while read -r window_id window_name window_panes window_layout; do
    if [ "$window_id" -eq "$first_win_id" ]; then
        cat >> "$TARGET_FILE" <<EOF
tmux rename-window -t "\$SESSION_NAME:$window_id" "$window_name"
EOF
else
    cat >> "$TARGET_FILE" <<EOF
tmux new-window -t "\$SESSION_NAME" -n "$window_name"
EOF
    fi

    for (( i = 1; i < window_panes; i++ )); do
        cat >> "$TARGET_FILE" <<EOF
tmux split-window -t "\$SESSION_NAME:$window_id"
tmux select-layout -t "\$SESSION_NAME:$window_id" tiled
EOF
    done

    cat >> "$TARGET_FILE" <<EOF
tmux select-layout -t "\$SESSION_NAME:$window_id" "$window_layout"
EOF

done < <(tmux list-windows -t "$SESSION_NAME" -F '#{window_index} #{window_name} #{window_panes} #{window_layout}')

cat >> "$TARGET_FILE" <<EOF
tmux select-window -t "\$SESSION_NAME:$first_win_id"
EOF

chmod +x "$TARGET_FILE"
tmux display-message "Layout captured at: $TARGET_FILE"
