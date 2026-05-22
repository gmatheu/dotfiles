#!/usr/bin/env bash
# rpa-trigger.sh
#
# Triggers an RPA automation script for the given password entry.
#
# Usage:
#   rpa-trigger.sh <password-name>

set -euo pipefail

password="${1:-}"
if [[ -z "$password" ]]; then
  echo "Error: password name required" >&2
  exit 1
fi

rpa_home="$HOME/.config/i3/rpa"

if ! cd "$rpa_home" 2>/dev/null; then
  notify-send -u critical -t 2000 "Pass" "Could not change directory to $rpa_home"
  exit 1
fi

rpa_script="./$(echo "$password" | sed -e 's#/#_#').sh"

if [[ ! -f "$rpa_script" ]]; then
  notify-send -u critical -t 2000 "Pass" "RPA script not found: \n\t$rpa_script"
  exit 1
fi

notify-send -u low -t 2000 "Pass" "Triggering RPA: \n\t$password"
"$rpa_script"
