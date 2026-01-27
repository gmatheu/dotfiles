#!/bin/bash

if [ "$1" = "Test" ]; then
	# Send a response
	echo "$@" | tee -a /tmp/test-hook.log
fi
