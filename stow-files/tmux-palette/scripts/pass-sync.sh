#!/usr/bin/env bash
# pass-sync.sh
#
# Synchronizes the password store with its git remote.
#
# Usage:
#   pass-sync.sh pull
#   pass-sync.sh push

set -euo pipefail

action="${1:-}"
if [[ -z "$action" ]]; then
  echo "Error: action required (pull or push)" >&2
  exit 1
fi

case "$action" in
  pull)
    output=$(pass git pull 2>&1)
    notify-send -u low -t 5000 "Pass" "Pulling changes from remote\n$output"
    ;;
  push)
    output=$(pass git push 2>&1)
    notify-send -u low -t 5000 "Pass" "Pushing changes to remote\n$output"
    ;;
  *)
    echo "Error: unknown action '$action' (expected: pull or push)" >&2
    exit 1
    ;;
esac
