#!/bin/bash

# Define package managers with display names and commands
declare -A UPGRADERS=(
	["nala (APT)"]="sudo nala upgrade -y"
	["kitty (terminal)"]="curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"
	["eget"]="eget --upgrade-all"
	["flatpak"]="flatpak upgrade"
	["snap"]="sudo snap refresh"
)

# Prepare items for fzf
declare -a ITEMS
for name in "${!UPGRADERS[@]}"; do
	ITEMS+=("$name")
done

# Show fzf menu with multi-select
# Ctrl+A selects all, Tab toggles selection
SELECTED=$(printf '%s\n' "${ITEMS[@]}" | fzf \
	--multi \
	--prompt="Select package managers to update (Tab: toggle, Ctrl+A: select all): " \
	--header="Use Tab to select multiple, Ctrl+A to select all, Enter to confirm" \
	--bind 'ctrl-a:select-all' \
	--bind 'ctrl-d:deselect-all' \
	--height=60% \
	--border)

# Exit if nothing selected
[[ -z "$SELECTED" ]] && echo "No selection made. Exiting." && exit 0

# Execute selected upgraders
echo "$SELECTED" | while IFS= read -r selection; do
	command="${UPGRADERS[$selection]}"
	echo ""
	echo "========================================"
	echo "Running: $selection"
	echo "Command: $command"
	echo "========================================"
	eval "$command"
done

echo ""
echo "All selected updates complete!"
