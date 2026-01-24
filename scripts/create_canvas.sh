#!/usr/bin/env bash

CANVAS_NAME="$1"
CANVAS_DIR="$HOME/.tmux-canvases"
CANVAS_PATH="$CANVAS_DIR/${CANVAS_NAME}.sh"

mkdir -p "$CANVAS_DIR"

if [ ! -f "$CANVAS_PATH" ]; then
    echo "Creating new canvas template: $CANVAS_PATH"
    
    cat <<EOF > "$CANVAS_PATH"
#!/usr/bin/env bash
# Canvas: $CANVAS_NAME
# Created: $(date)

# Setup Windows and Panes
tmux rename-window "editor"
tmux send-keys "nvim ." C-m

tmux split-window -h -p 30
tmux send-keys "echo 'Terminal ready'" C-m

tmux select-pane -t 0
EOF
    chmod +x "$CANVAS_PATH"
fi

source "$CANVAS_PATH"
