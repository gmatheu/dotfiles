# OpenCode Notifier Notify-Send Script Enhancement

**Date:** 2026-04-21

## Request

Complete the `opencode-notifier-notify-send.sh` script so that it dynamically builds the `notify-send` message from the log file instead of showing a hardcoded example.

## What Was Implemented

### File: `stow-files/opencode/scripts/opencode-notifier-notify-send.sh`

- **Log parsing**: Reads `$HOME/.local/share/opencode/opencode-notifier.log` line by line.
- **Field extraction**: Extracts `event`, `projectName`, and `currentTimestamp` from the pipe-separated log format.
- **Per-project deduplication**: Only keeps the latest entry per `projectName` (overwrites earlier entries as it reads).
- **Icon mapping**: Maps events to colored circle icons:
  - `client_connected` → 🔵
  - `session_started` → 🟠
  - `user_message` → 🟡
  - `complete` → 🟢
  - `error` → 🔴
  - `question` → ❓
  - fallback → ⚪
- **Relative time**: Converts `currentTimestamp` to epoch and computes human-readable relative time (`Xs ago`, `Xm ago`, `Xh ago`, `Xd ago`).
- **Sorting**: Orders projects by most recent event first (using `sort -t'|' -k1,1 -nr`).
- **Message formatting**: Joins lines with `\n` for `notify-send`.

### File: `stow-files/opencode/scripts/opencode-notifier.sh`

- Supporting logger script that appends events to the log file in the expected format.
- Includes log rotation when file size exceeds 1MB (keeps last 5000 lines).

## Log Format

The log file uses pipe-separated key:value pairs:

```
event:TYPE|message:TEXT|sessionTitle:TITLE|agentName:NAME|projectName:PROJECT|timestamp:HH:MM:SS|turn:N|currentTimestamp:YYYY-MM-DD HH:MM:SS
```

## Notes

- The script only shows **one message per project** (the most recent one).
- The example log entries in comments at the top of the file are kept as documentation of the expected format.
- The notifier is meant to be called periodically (e.g., via cron or polybar) to show a system tray / desktop notification of recent OpenCode agent activity.
