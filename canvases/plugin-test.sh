#!/usr/bin/env bash
# Canvas: plugin-test
# Saved on: 2026-03-31 15:01:29

PROJECT_DIR="/home/cruzj/Projects/tmux-canvas-plugin/test"

# Set directory for first pane
tmux send-keys -t "$SESSION_NAME:0" "cd $PROJECT_DIR" C-m
sleep 0.3

tmux new-window -t "$SESSION_NAME" -n "nvim" -c "/home/cruzj/Projects/tmux-canvas-plugin/test"
tmux split-window -t "$SESSION_NAME:1" -c "/home/cruzj/Projects/tmux-canvas-plugin/test"
tmux select-layout -t "$SESSION_NAME:1" tiled

# Return to first window
tmux select-window -t "$SESSION_NAME:0"
tmux select-pane -t 0
