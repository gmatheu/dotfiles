#!/bin/bash

## Best can do effort to search for eget installed packages and include in pre-selected list
atuin search --search-mode prefix eget --format "{command}" | sed -e 's/eget//' | tr -s ' ' | grep -v -e 'rm' -e '-r' -e '--' | fzf --prompt 'Select eget packages to update > ' -m | tee -a ~/.config/eget/to-update.txt
