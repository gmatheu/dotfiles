#!/bin/bash

## Show active connections and allows to manage them
openvpn3 sessions-list | grep -e 'No sessions available' && exit
openvpn3 sessions-list | grep -v -e '--' | grep -e 'Path' -e 'Status' -e 'Config name' | tr -s ' ' | paste -sd ' ' | sed -e 's/  / |  /' |
	fzf --bind 'enter:become(openvpn3 session-stats --path {2})' \
		--preview 'openvpn3 session-stats --path {2}' \
		--bind 'ctrl-s:become(openvpn3 session-manage --disconnect --path {2})' \
		--prompt 'Enter: Stats, C-s: Disconnect  > '
