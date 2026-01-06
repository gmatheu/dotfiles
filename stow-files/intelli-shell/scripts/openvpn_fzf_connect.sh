#!/bin/bash

## Show configs and allows to connect
openvpn3 configs-list | tac | grep -v -e '--' |
	fzf --bind 'enter:become(openvpn3 session-start --config {1})' \
		--prompt 'Enter: Start session  > '
