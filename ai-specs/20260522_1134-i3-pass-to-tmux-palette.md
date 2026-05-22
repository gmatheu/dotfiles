# i3-pass to Tmux-palette Conversion

**Date:** 20260522_1134
**Feature:** Convert the Rofi-based i3-pass password management script to a tmux-palette configuration with auxiliary scripts

## Request

Convert the Rofi based script for password management (`stow-files/i3/bin/i3-pass`) to a Tmux-palette format (https://github.com/eduwass/tmux-palette) configuration in `stow-files/tmux-palette/palettes/password-store.json`. Create any auxiliary scripts (e.g: `copy-password.sh <password-name>` to copy specific password and notify) in `stow-files/tmux-palette/scripts/` (stowed to `~/.config/tmux-palette/scripts`).

### Clarifications

No further clarifications were requested. The implementation preserved all original capabilities (password copy, TOTP, sync actions, RPA trigger) and adapted them to tmux-palette's static-item architecture.

## Implementation

### Updated Files
- **`stow-files/tmux-palette/palettes/password-store.json`** — Replaced static items with a `command` field pointing to `~/.config/tmux-palette/scripts/generate-password-palette.sh`. This leverages tmux-palette's dynamic generation escape hatch so the palette regenerates on every open.

### New Scripts
All scripts are placed in `stow-files/tmux-palette/scripts/` and target `~/.config/tmux-palette/scripts` when stowed.

| Script | Purpose |
|---|---|
| `generate-password-palette.sh` | Dynamically generates tmux-palette JSON with sync actions, LRU history, password entries, and TOTP entries |
| `copy-password.sh <name>` | Copies the first line of a pass entry to the clipboard, updates LRU history, and notifies via `notify-send` |
| `copy-totp.sh <name>` | Executes the corresponding TOTP script (`~/.password-store/totp/<name>.totp.sh`) and copies the generated code to the clipboard |
| `pass-sync.sh <pull\|push>` | Runs `pass git pull` or `pass git push` and notifies with the command output |
| `copy-password-name.sh <name>` | Copies just the entry name (not the secret) to the clipboard |
| `rpa-trigger.sh <name>` | Triggers the RPA automation script (`~/.config/i3/rpa/<name_with_underscores>.sh`) for the entry |

### Key Implementation Details
- **`generate-password-palette.sh`** embeds a Python heredoc that uses `pass git ls-files`, `Counter.most_common()` for LRU ranking, and `pathlib` for TOTP discovery. It outputs a flat JSON array of tmux-palette item objects.
- All shell scripts accept the password/TOTP name as a positional argument and perform basic validation before proceeding.
- Scripts use `xclip -selection clipboard` for clipboard integration and `notify-send` for desktop notifications, consistent with the original i3-pass behavior.

## Design Decisions

- **Dynamic generation via `command` field**: tmux-palette's native format is static JSON. Because the password store changes frequently, the palette JSON is generated on-the-fly by `generate-password-palette.sh` instead of being maintained manually.
- **Separate LRU history file**: LRU tracking uses `~/.local/share/tmux-pass-history.txt`, isolated from the old i3-pass history (`~/.local/share/i3-pass-history.txt`) to avoid conflicts between the two tools.
- **Safe shell argument passing**: The Python generator uses `shlex.quote()` when constructing shell commands for each palette item, preventing issues with entries containing spaces or special characters.
- **Strict shell scripting**: All new scripts use `set -euo pipefail` to follow the repository's shell conventions and fail fast on errors.
- **Single default action per item**: The original Rofi script supported modifier-key alternative actions (`Ctrl+Enter` to copy name, `Ctrl+Shift+Enter` to trigger RPA). tmux-palette does not support this, so each palette item defaults to the most common action — copying the password. The less common actions (copy name, trigger RPA) are exposed as separate standalone scripts for users who want to add them as additional palette items manually.

## Testing

- Run `generate-password-palette.sh` directly and validate that it outputs well-formed JSON.
- Execute `copy-password.sh` with a known pass entry and verify the clipboard content and notification.
- Execute `pass-sync.sh pull` and `pass-sync.sh push` to confirm git sync actions and notifications.
- Execute `copy-totp.sh` with an existing TOTP script to verify code generation and clipboard copy.
- Execute `rpa-trigger.sh` with an entry that has a matching RPA script and confirm it runs.
- Verify that `copy-password.sh` appends to `~/.local/share/tmux-pass-history.txt` and that `generate-password-palette.sh` surfaces recent entries correctly.
- Run `shellcheck` on all new `.sh` scripts.
