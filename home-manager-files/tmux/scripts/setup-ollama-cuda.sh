#! /bin/bash

tmux split-window -h -d
tmux split-window -h -d
tmux split-window -h -d

tmux select-layout main-vertical

tmux send-keys -t 4 nvtop Enter
tmux send-keys -t 4 Enter

tmux send-keys -t 3 'pipx run nvitop' Enter

tmux send-keys -t 2 'ollama serve' Enter
tmux resize-pane -t 2 -U 4
