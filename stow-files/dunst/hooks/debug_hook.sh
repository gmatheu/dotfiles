#!/usr/bin/env bash
# ~/.config/dunst/hooks/debug_hook.sh

# Log the raw arguments Dunst passes
logfile="$HOME/.cache/dunst_hook.log"
{
  echo "=== $(date '+%Y-%m-%d %H:%M:%S') ==="
  echo "Hook invoked with args: $@"
  echo "Environment:"
  env | grep -E '^(DUNST_|HOME|USER|PATH)='
  echo "--- STDIN ---"
  cat -
  echo "=== END ==="
} | tee -a "$logfile"
