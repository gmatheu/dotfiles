#!/usr/bin/env bash
# copy-password-name.sh
#
# Copies the password entry name to the clipboard.
#
# Usage:
#   copy-password-name.sh <password-name>

set -euo pipefail

password="${1:-}"
if [[ -z "$password" ]]; then
  echo "Error: password name required" >&2
  exit 1
fi

if echo "$password" | xclip -selection clipboard; then
  notify-send -u low -t 5000 "Pass" "Password name copied to clipboard: \n\t$password"
else
  notify-send -u critical -t 5000 "Pass" "Could not copy password name to clipboard: \n\t$password"
fi
