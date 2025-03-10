#! /bin/bash

SCRIPTS_HOME=~/.config/intelli-shell/scripts/
find -L ${SCRIPTS_HOME} -name '*.sh' -printf '%f\n' |
  fzf \
    --prompt "ctrl-e: edit / Enter: execute > " \
    --preview "cat ${SCRIPTS_HOME}{}" \
    --bind "ctrl-e:execute($EDITOR ${SCRIPTS_HOME}{}),enter:become(bash ${SCRIPTS_HOME}{})"
