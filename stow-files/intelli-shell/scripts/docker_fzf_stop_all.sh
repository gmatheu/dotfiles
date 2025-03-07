#!/bin/bash

## Stop all running containers
docker ps | fzf --multi --prompt 'Enter to stop container / Ctrl-a: select all / Ctrl-d: deselect all / Ctrl-t: toggle > ' --bind 'ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all,enter:become(echo {1})' | xargs -I{} docker stop {}
