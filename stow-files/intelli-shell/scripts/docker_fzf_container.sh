#!/bin/bash

## Stops a docker container
docker ps | fzf --preview 'docker inspect {1}' --prompt "Enter to container / C-p to stop container > " --bind "ctrl-p:become(docker stop {1}),enter:become(docker stop {1})"
