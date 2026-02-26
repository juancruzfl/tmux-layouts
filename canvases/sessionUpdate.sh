#!/usr/bin/env bash
# Canvas: sessionUpdate
# Saved on: 2026-02-26 15:01:20

PROJECT_DIR="/home/cruzj/Projects/tmux-canvas-plugin"

# Set directory for first pane
tmux send-keys -t "$SESSION_NAME:0" "cd $PROJECT_DIR" C-m
sleep 0.3

tmux new-window -t "$SESSION_NAME" -n "bash" -c "/home/cruzj/Projects/tmux-canvas-plugin"
tmux split-window -t "$SESSION_NAME:1" -c "/home/cruzj/Projects/tmux-canvas-plugin"
tmux select-layout -t "$SESSION_NAME:1" tiled
tmux new-window -t "$SESSION_NAME" -n "test1" -c "/home/cruzj/Projects/tmux-canvas-plugin"
tmux split-window -t "$SESSION_NAME:2" -c "/home/cruzj/Projects/tmux-canvas-plugin"
tmux select-layout -t "$SESSION_NAME:2" tiled
tmux new-window -t "$SESSION_NAME" -n "bash" -c "/home/cruzj/Projects/tmux-canvas-plugin/canvases"
tmux split-window -t "$SESSION_NAME:3" -c "/home/cruzj/Projects/tmux-canvas-plugin/canvases"
tmux select-layout -t "$SESSION_NAME:3" tiled
tmux new-window -t "$SESSION_NAME" -n "bash" -c "/home/cruzj/Projects/tmux-canvas-plugin"
tmux split-window -t "$SESSION_NAME:4" -c "/home/cruzj/Projects/tmux-canvas-plugin"
tmux select-layout -t "$SESSION_NAME:4" tiled

# Return to first window
tmux select-window -t "$SESSION_NAME:0"
tmux select-pane -t 0
