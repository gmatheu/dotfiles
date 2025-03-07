#!/bin/bash

## Updates eget packages from pre-selected list
cat ~/.config/eget/to-update.txt | fzf --prompt "c-a select all / c-d deselect all > " -m --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all | xargs -I{} eget {}
