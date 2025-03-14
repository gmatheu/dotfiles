#! /bin/bash

SCRIPTS_HOME=~/.config/intelli-shell/scripts/
find -L ${SCRIPTS_HOME} -name '*.sh' -printf '%f\n' |
  fzf \
    --prompt "ctrl-e: edit / Enter: execute > " \
    --preview "cat ${SCRIPTS_HOME}{}" \
    --bind "ctrl-e:execute($EDITOR ${SCRIPTS_HOME}{}),enter:execute-silent(atuin history start "${SCRIPTS_HOME}{}")+execute-silent(print -s "${SCRIPTS_HOME}{}")+become(bash ${SCRIPTS_HOME}{})"
