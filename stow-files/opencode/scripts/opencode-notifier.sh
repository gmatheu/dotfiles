#!/bin/bash

#{event}, {message}, {sessionTitle}, {agentName}, {projectName}, {timestamp}, and {turn}
event=$1
message=$2
sessionTitle=$3
agentName=$4
projectName=$5
timestamp=$6
turn=$7

# notify-send "$1\t$2\t$3\t$4\t$5\t$6\t$7"
currentTimestamp=$(date '+%Y-%m-%d %H:%M:%S')
log_file=$HOME/.local/share/opencode/opencode-notifier.log

max_log_size=1048576
keep_lines=5000

if [ -f "$log_file" ] && [ "$(stat -c %s "$log_file" 2>/dev/null || stat -f %z "$log_file" 2>/dev/null)" -gt "$max_log_size" ]; then
    tail -n "$keep_lines" "$log_file" > "$log_file.tmp" && mv "$log_file.tmp" "$log_file"
fi

echo "event:$1|message:$2|sessionTitle:$3|agentName:$4|projectName:$5|timestamp:$6|turn:$7|currentTimestamp:$currentTimestamp" >>"$log_file"
