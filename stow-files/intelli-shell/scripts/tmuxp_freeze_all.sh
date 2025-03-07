#!/bin/bash

## Stores all tmux sessions as tmuxp files
tmux list-sessions | cut -d : -f 1 | xargs -i{} uvx tmuxp freeze --yes --force -o ${HOME}/.tmuxp/{}.yaml {}
