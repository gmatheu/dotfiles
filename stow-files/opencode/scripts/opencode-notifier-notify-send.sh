#!/bin/bash

log_file=$HOME/.local/share/opencode/opencode-notifier.log

# Example log entries:
# event:client_connected|message:OpenCode connected|sessionTitle:|agentName:|projectName:.dotfiles|timestamp:10:54:42|turn:54|currentTimestamp:2026-04-20 10:58:07
# event:client_connected|message:OpenCode connected|sessionTitle:|agentName:|projectName:.dotfiles|timestamp:10:56:57|turn:55|currentTimestamp:2026-04-20 10:58:07
# event:session_started|message:Session started: New session - 2026-04-21T13:57:56.571Z|sessionTitle:New session - 2026-04-21T13:57:56.571Z|agentName:|projectName:.dotfiles|timestamp:10:57:56|turn:56|currentTimestamp:2026-04-20 10:58:07
# event:user_message|message:User sent a message|sessionTitle:|agentName:|projectName:.dotfiles|timestamp:10:57:56|turn:57|currentTimestamp:2026-04-20 10:58:07
# event:user_message|message:User sent a message|sessionTitle:|agentName:|projectName:.dotfiles|timestamp:10:57:56|turn:58|currentTimestamp:2026-04-20 10:58:07
# event:user_message|message:User sent a message|sessionTitle:|agentName:|projectName:.dotfiles|timestamp:10:58:02|turn:59|currentTimestamp:2026-04-20 10:58:07
# event:user_message|message:User sent a message|sessionTitle:|agentName:|projectName:.dotfiles|timestamp:10:58:07|turn:60|currentTimestamp:2026-04-21 10:58:07
# event:user_message|message:User sent a message|sessionTitle:|agentName:|projectName:.dotfiles|timestamp:10:58:09|turn:61|currentTimestamp:2026-04-21 10:58:09
# event:user_message|message:User sent a message|sessionTitle:|agentName:|projectName:.dotfiles|timestamp:10:58:12|turn:62|currentTimestamp:2026-04-21 10:58:12
# event:complete|message:Session has finished: Opencode-notifier.sh log fields enhancement plan|sessionTitle:Opencode-notifier.sh log fields enhancement plan|agentName:|projectName:.dotfiles|timestamp:10:58:13|turn:63|currentTimestamp:2026-04-21 10:58:12

client_connected_icon='🔵'
session_started_icon='🟠'
user_message_icon='🟡'
complete_icon='🟢'
error_icon='🔴'
question_icon='❓'

declare -A latest_event
declare -A latest_timestamp

if [[ -f "$log_file" ]]; then
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue

    event=""
    projectName=""
    currentTimestamp=""

    IFS='|' read -ra fields <<< "$line"
    for field in "${fields[@]}"; do
      key="${field%%:*}"
      value="${field#*:}"
      case "$key" in
        event) event="$value" ;;
        projectName) projectName="$value" ;;
        currentTimestamp) currentTimestamp="$value" ;;
      esac
    done

    if [[ -n "$projectName" && -n "$currentTimestamp" ]]; then
      latest_event["$projectName"]="$event"
      latest_timestamp["$projectName"]="$currentTimestamp"
    fi
  done < "$log_file"
fi

declare -a lines
now_epoch=$(date +%s)

for project in "${!latest_event[@]}"; do
  event="${latest_event[$project]}"
  ts="${latest_timestamp[$project]}"

  icon='⚪'
  case "$event" in
    client_connected) icon="$client_connected_icon" ;;
    session_started) icon="$session_started_icon" ;;
    user_message) icon="$user_message_icon" ;;
    complete) icon="$complete_icon" ;;
    error) icon="$error_icon" ;;
    question) icon="$question_icon" ;;
  esac

  ts_epoch=$(date -d "$ts" +%s 2>/dev/null || echo 0)

  if ((ts_epoch > 0)); then
    diff=$((now_epoch - ts_epoch))
    if ((diff < 60)); then
      time_ago="${diff}s ago"
    elif ((diff < 3600)); then
      time_ago="$((diff / 60))m ago"
    elif ((diff < 86400)); then
      time_ago="$((diff / 3600))h ago"
    else
      time_ago="$((diff / 86400))d ago"
    fi
  else
    time_ago="unknown"
  fi

  lines+=("$ts_epoch|$icon: $project ($time_ago)")
done

message=""
if (( ${#lines[@]} > 0 )); then
  IFS=$'\n' sorted=($(printf '%s\n' "${lines[@]}" | sort -t'|' -k1,1 -nr))
  unset IFS

  first=true
  for line in "${sorted[@]}"; do
    if [[ "$first" == true ]]; then
      message+="${line#*|}"
      first=false
    else
      message+="\\n${line#*|}"
    fi
  done
fi

notify-send --app-name=opencode-notifier 'Opencode Agents' "$message"
