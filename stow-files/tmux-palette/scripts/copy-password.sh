#!/usr/bin/env bash
# copy-password.sh
#
# Copies the first line of a pass entry to the clipboard and updates LRU history.
#
# Usage:
#   copy-password.sh <password-name>

set -euo pipefail

password="${1:-}"
if [[ -z "$password" ]]; then
  echo "Error: password name required" >&2
  exit 1
fi

history_file="$HOME/.local/share/tmux-pass-history.txt"
mkdir -p "$(dirname "$history_file")"
echo "$password" >> "$history_file"
sed -n '1,50 p' -i "$history_file"

if pass show "$password" | head -n 1 | xclip -selection clipboard; then
  notify-send -u low -t 5000 "Pass" "Password copied to clipboard: \n\t$password"
else
  notify-send -u critical -t 5000 "Pass" "Could not copy password to clipboard: \n\t$password"
fi
