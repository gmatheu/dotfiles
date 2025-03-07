#! /bin/bash

find -L ~/.config/intelli-shell/scripts/ -name '*.sh' | fzf --preview 'cat {}' --bind "ctrl-e:become($EDITOR {}),enter:become(bash {})"
