# Summary: Zsh Plugin Manager Modernization

**Date:** 2026-03-06  
**Files Modified:** `stow-files-home/dot-zshrc`  
**Session:** ses_33c723b6bffe17R4V7AIUM5uWc

## Request

Replace the existing zplug plugin manager with modern alternatives (antidote or sheldon), maintaining backward compatibility with existing zplug setup. Requirements:
- Add functions similar to `load_zplug` for loading new plugin managers
- Add functions similar to `apply_zplug_bundles` for applying equivalent plugins
- Add environment variables to determine which plugin manager to use
- Support both antidote (https://github.com/mattmc3/antidote) and sheldon (https://github.com/rossmacarthur/sheldon)

## Implementation

### Environment Variable Configuration (lines 20-25)

Added `ZSH_PLUGIN_MANAGER` variable with three supported options: `zplug`, `antidote`, or `sheldon`.

```zsh
export ZSH_PLUGIN_MANAGER=${ZSH_PLUGIN_MANAGER:-zplug}
```

### New Loading Functions

**`load_antidote()`** (lines 39-48):
- Auto-installs antidote from GitHub releases if not present at `~/.antidote`
- Sources the antidote.zsh loader script

**`load_sheldon()`** (lines 50-62):
- Checks if sheldon binary is available (requires manual installation via cargo, eget, or package manager)
- Creates default config directory and file at `~/.config/sheldon/plugins.toml` if missing
- Uses `eval "$(sheldon source)"` to load plugins dynamically

### New Bundle Functions

**`apply_antidote_bundles()`** (lines 151-221):
- Generates `~/.zsh_plugins.txt` with all equivalent plugins in antidote format
- Uses path syntax for oh-my-zsh plugins (e.g., `ohmyzsh/ohmyzsh path:plugins/git`)
- Supports conditional spaceship theme loading (skipped when `USE_STARSHIP` is set)
- Includes regeneration control via `ANTIDOTE_REGENERATE` environment variable

**`apply_sheldon_bundon_bundles()`** (lines 223-390):
- Generates `~/.config/sheldon/plugins.toml` with comprehensive TOML configuration
- Maps all shell-plugins subdirectories as individual plugins
- Configures oh-my-zsh plugins using sheldon's template system
- Includes all custom plugins: dirrc, git, notify, vim, clipboard, grep, fast-server, quick-file-actions, profile-secrets, fzf, version-managers, password-store, file-compression, gcloud, kubectl, aws, rclone-fzf, telegram, ssh-agent, zplug-helper, npm-scripts, tmux, ripgrep
- Supports regeneration control via `SHELDON_REGENERATE` environment variable

### Plugin Mapping Reference

The following plugins were mapped from zplug to both antidote and sheldon formats:

| Plugin | Zplug Syntax | Antidote/Sheldon Equivalent |
|--------|--------------|----------------------------|
| zsh-history-substring-search | `zsh-users/zsh-history-substring-search` | Same |
| shell-plugins/dirrc | `gmatheu/shell-plugins use:'dirrc/*.sh'` | Same repo with `use: dirrc/*.sh` |
| shell-plugins/git | `gmatheu/shell-plugins use:'git/*.zsh'` | Same repo with `use: git/*.zsh` |
| oh-my-zsh plugins | `plugins/git from:oh-my-zsh` | `ohmyzsh/ohmyzsh path:plugins/git` |
| spaceship-prompt | `spaceship-prompt/spaceship-prompt use:spaceship.zsh as:theme` | Same with `as: theme` |

### Updated Loading Logic (lines 475-506)

Replaced the original `SKIP_ZPLUG` conditional block with a new `load_plugins()` function:

```zsh
function load_plugins() {
  case "$ZSH_PLUGIN_MANAGER" in
    antidote)
      # Load antidote and apply bundles
      ;;
    sheldon)
      # Load sheldon and apply bundles
      ;;
    zplug|*)
      # Default to zplug (backward compatible)
      ;;
  esac
}
```

### Environment Variable Controls

The implementation supports multiple control variables:

- `ZSH_PLUGIN_MANAGER`: Select which manager to use (`zplug`, `antidote`, `sheldon`)
- `SKIP_ZPLUG`: Skip loading zplug (legacy, still supported)
- `SKIP_ANTIDOTE`: Skip loading antidote
- `SKIP_SHELDON`: Skip loading sheldon
- `ANTIDOTE_REGENERATE`: Force regeneration of `~/.zsh_plugins.txt`
- `SHELDON_REGENERATE`: Force regeneration of `~/.config/sheldon/plugins.toml`

### Usage Examples

```zsh
# Use antidote instead of zplug
export ZSH_PLUGIN_MANAGER=antidote

# Use sheldon instead of zplug
export ZSH_PLUGIN_MANAGER=sheldon

# Skip plugin loading entirely
export SKIP_ZPLUG=1
export SKIP_ANTIDOTE=1
export SKIP_SHELDON=1

# Force plugin list regeneration
export ANTIDOTE_REGENERATE=1
export SHELDON_REGENERATE=1
```

## Architecture Notes

- **Backward Compatibility**: The default behavior remains unchanged (zplug is used when `ZSH_PLUGIN_MANAGER` is unset)
- **Config File Generation**: Both antidote and sheldon implementations generate their configuration files dynamically from the bundle functions, ensuring consistency with zplug's plugin list
- **Auto-installation**: Only antidote supports automatic installation; sheldon requires manual installation due to its Rust-based distribution model
- **Template Support**: Sheldon implementation leverages its powerful template system to replicate oh-my-zsh plugin loading behavior
- **Conditional Loading**: Spaceship theme is conditionally loaded based on `USE_STARSHIP` environment variable across all three managers

## Future Considerations

- **Sheldon Installation**: Users need to install sheldon manually via cargo (`cargo install sheldon`), eget, or system package manager
- **Performance**: Antidote is generally faster than zplug due to its compiled static loading approach; sheldon offers TOML-based declarative configuration
- **Migration Path**: Users can test new managers by setting `ZSH_PLUGIN_MANAGER` before sourcing `.zshrc`, then make permanent in `.zshenv` or `.profile`
- **Config Files**: The generated `~/.zsh_plugins.txt` (antidote) and `~/.config/sheldon/plugins.toml` (sheldon) can be customized further if needed, though regeneration will overwrite manual changes unless `*_REGENERATE` is unset
