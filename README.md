# Terminal Setup

Profile-based terminal configuration manager for `zsh`, `tmux`, and related tools.

## Requirements

- Bash 4+
- Git

## Quick start

```bash
git clone <repo> ~/terminal-setup
cd ~/terminal-setup

# See available profiles and backups
bash bin/terminal-setup.sh list

# Install a profile (backs up your current config first)
bash bin/terminal-setup.sh install dev
```

On Linux, the `dev` profile installer will run `apt-get` to install dependencies
(`zsh`, `tmux`, `bat`, `fzf`, `eza`, `fonts-powerline`) and set up Oh My Zsh if
it isn't already present.

## Commands

| Command | Description |
|---|---|
| `list` | Show available profiles and saved backups |
| `backup [-rm] [label]` | Save current terminal state to `backups/` (default: manual), or `-rm` to remove a backup |
| `install <profile>` | Back up, install deps, then apply a profile |
| `restore <backup>` | Roll back to a previously saved backup |

## Restoring a backup

```bash
bash bin/terminal-setup.sh list          # find the backup name
bash bin/terminal-setup.sh restore <name>
```

Restore always saves a safety backup of the current state before overwriting anything.

## Adding a new profile

1. Create `profiles/<name>/`
2. Add dotfiles to `profiles/<name>/configs/` — they are copied verbatim to `$HOME`
3. Optionally add `profiles/<name>/requirements.sh` declaring `REQUIRED_COMMANDS`, `REQUIRED_PATHS`, and/or `REQUIRES_POWERLINE_FONT`
4. Optionally add `profiles/<name>/install/ubuntu.sh` (and/or `macos.sh`) for OS package setup
5. Run `bash bin/terminal-setup.sh install <name>`

## Environment variables

| Variable | Purpose |
|---|---|
| `TERMINAL_SETUP_HOME` | Override target home dir (default: `$HOME`) |
| `TERMINAL_SETUP_BACKUPS_DIR` | Override backups location (default: `backups/`) |
| `TERMINAL_SETUP_SKIP_OS_INSTALL` | Set to `1` to skip running the OS installer |
| `TERMINAL_SETUP_ASSUME_YES` | Set to `1` to skip confirmation prompts |

Safe test run example:

```bash
TERMINAL_SETUP_HOME=/tmp/test-home \
TERMINAL_SETUP_BACKUPS_DIR=/tmp/test-backups \
TERMINAL_SETUP_SKIP_OS_INSTALL=1 \
  bash bin/terminal-setup.sh install dev
```
