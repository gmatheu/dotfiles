#!/bin/bash

## Import scripts into intelli-shell
grep -R -e '^##.*' . | sed -e 's/:/ /' | sed -e 's#./#${HOME}/.config/intelli-shell/#' >/tmp/clt_user_commands.txt
intelli-shell import /tmp/clt_user_commands.txt
