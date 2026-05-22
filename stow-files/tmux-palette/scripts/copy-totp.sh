#!/usr/bin/env bash
# copy-totp.sh
#
# Executes a TOTP script and copies the generated code to the clipboard.
#
# Usage:
#   copy-totp.sh <totp-name>

set -euo pipefail

totp_name="${1:-}"
if [[ -z "$totp_name" ]]; then
  echo "Error: TOTP name required" >&2
  exit 1
fi

totp_script="$HOME/.password-store/totp/${totp_name}.totp.sh"

if [[ ! -f "$totp_script" ]]; then
  notify-send -u critical -t 5000 "Pass: TOTP" "TOTP script not found: \n\t$totp_name"
  exit 1
fi

if bash "$totp_script" | tr -d '\n' | xclip -selection clipboard; then
  notify-send -u low -t 5000 "Pass: TOTP" "TOTP password copied to clipboard: \n\t$totp_name"
else
  notify-send -u critical -t 5000 "Pass: TOTP" "Could not copy TOTP to clipboard: \n\t$totp_name"
fi
