#!/bin/bash

## Shows and loads tmuxp sessions interactively
uvx tmuxp ls | fzf --preview 'bat ${HOME}/.tmuxp/{}.yaml' --prompt "Enter: load / Ctrl-e: edit > " --bind 'ctrl-e:become(uvx tmuxp edit {}),enter:become(uvx tmuxp load {})'
