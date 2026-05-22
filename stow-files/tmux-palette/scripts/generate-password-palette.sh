#!/usr/bin/env bash
# generate-password-palette.sh
#
# Dynamically generates a tmux-palette JSON array of password store items.
# Lists sync actions, LRU history, password entries, and TOTP entries.
#
# Usage:
#   ~/.config/tmux-palette/scripts/generate-password-palette.sh

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
history_file="$HOME/.local/share/tmux-pass-history.txt"
lru_entries=5

mkdir -p "$(dirname "$history_file")"
touch "$history_file"

python3 - "$script_dir" "$history_file" "$lru_entries" <<'PY'
import json
import os
import shlex
import subprocess
import sys
from collections import Counter
from pathlib import Path

script_dir = sys.argv[1]
history_file = sys.argv[2]
lru_count = int(sys.argv[3])

items = []

# ---------------------------------------------------------------------------
# Sync actions
# ---------------------------------------------------------------------------
items.append(
    {
        "icon": "󰕥",
        "category": "Sync",
        "title": "passupdate: Pull from remote",
        "action": {"shell": f"{script_dir}/pass-sync.sh pull"},
    }
)
items.append(
    {
        "icon": "󰕝",
        "category": "Sync",
        "title": "passpush: Push to remote",
        "action": {"shell": f"{script_dir}/pass-sync.sh push"},
    }
)

# ---------------------------------------------------------------------------
# LRU history entries
# ---------------------------------------------------------------------------
if os.path.exists(history_file) and os.path.getsize(history_file) > 0:
    with open(history_file) as f:
        lines = [line.strip() for line in f if line.strip()]
    counts = Counter(lines)
    for entry, _ in counts.most_common(lru_count):
        items.append(
            {
                "icon": "󰷛",
                "category": "Recent",
                "title": entry,
                "action": {
                    "shell": f"{script_dir}/copy-password.sh {shlex.quote(entry)}"
                },
            }
        )

# ---------------------------------------------------------------------------
# Password entries from pass
# ---------------------------------------------------------------------------
try:
    result = subprocess.run(
        ["pass", "git", "ls-files"],
        capture_output=True,
        text=True,
        check=True,
    )
    for line in sorted(result.stdout.strip().split("\n")):
        if not line or ".gpg-id" in line:
            continue
        entry = line.replace(".gpg", "")
        items.append(
            {
                "icon": "󰌆",
                "category": "Passwords",
                "title": entry,
                "action": {
                    "shell": f"{script_dir}/copy-password.sh {shlex.quote(entry)}"
                },
            }
        )
except (subprocess.CalledProcessError, FileNotFoundError):
    pass

# ---------------------------------------------------------------------------
# TOTP entries
# ---------------------------------------------------------------------------
totp_dir = Path.home() / ".password-store" / "totp"
if totp_dir.exists():
    for totp_file in sorted(totp_dir.glob("*.totp.sh")):
        totp_name = totp_file.name.replace(".totp.sh", "")
        items.append(
            {
                "icon": "󰄵",
                "category": "TOTP",
                "title": f"totp:{totp_name}",
                "action": {
                    "shell": f"{script_dir}/copy-totp.sh {shlex.quote(totp_name)}"
                },
            }
        )

print(json.dumps(items, indent=2))
PY
