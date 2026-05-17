#!/usr/bin/env bash
tmux rename-window "editor"
tmux send-keys "cd ~/projects" C-m
tmux send-keys "nvim ." C-m

tmux split-window -h -p 30
tmux send-keys "cd ~/projects" C-m

tmux new-window -n "servers"
tmux send-keys "cd ~/projects" C-m
tmux send-keys "npm run dev" C-m

tmux split-window -v
tmux send-keys "cd ~/projects/api" C-m
tmux send-keys "npm start" C-m

tmux new-window -n "git"
tmux send-keys "cd ~/projects" C-m
tmux send-keys "git status" C-m

tmux split-window -h
tmux send-keys "cd ~/projects" C-m
tmux send-keys "tail -f logs/app.log" C-m

tmux select-window -t 0
tmux select-pane -t 0
