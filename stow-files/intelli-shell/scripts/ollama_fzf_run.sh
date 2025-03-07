#!/bin/bash

## Shows and runs ollama locally available models
ollama list | fzf --preview 'ollama show {1}' --prompt "Enter to run model / C-p to remove model > " --bind "ctrl-p:become(ollama rm {1}),enter:become(ollama run {1})"
