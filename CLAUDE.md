# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Profile-based terminal configuration manager for zsh, tmux, and related tools. Written entirely in Bash.

## Commands

```bash
# Run the CLI
bash bin/terminal-setup.sh list|backup|install|restore

# Safe testing (avoids touching real $HOME or running apt-get)
TERMINAL_SETUP_HOME=/tmp/test-home \
TERMINAL_SETUP_BACKUPS_DIR=/tmp/test-backups \
TERMINAL_SETUP_SKIP_OS_INSTALL=1 \
  bash bin/terminal-setup.sh install dev

# Skip confirmation prompts
TERMINAL_SETUP_ASSUME_YES=1 bash bin/terminal-setup.sh install dev
```

No build step, no tests, no linter currently configured.

## Architecture

**Entry point:** `bin/terminal-setup.sh` — parses subcommands, sources all libs, sets global vars (`ROOT_DIR`, `PROFILES_DIR`, `BACKUPS_DIR`, `TARGET_HOME`).

**Libraries (`lib/`):**
- `ui.sh` — display helpers (`print_header`, `confirm`) and directory scanners (`find_profiles`, `find_backups`). Depends on globals from the entry point.
- `backup.sh` — `backup_current_state()` copies a fixed list of dotfiles (`BACKUP_FILES` array) from `$TARGET_HOME` into a timestamped backup dir.
- `install.sh` — profile lifecycle: `load_profile_requirements` (sources `requirements.sh`), `profile_precheck`, `run_profile_installer` (dispatches to OS-specific script), `apply_profile_files` (copies `configs/*` into `$TARGET_HOME`).
- `restore.sh` — `restore_backup()` creates a safety backup then copies files back from a named backup dir.

**Profile contract (`profiles/<name>/`):**
- `configs/` — dotfiles copied verbatim to `$TARGET_HOME`
- `requirements.sh` — sourced to populate `REQUIRED_COMMANDS`, `REQUIRED_PATHS`, `REQUIRES_POWERLINE_FONT`
- `install/<os>.sh` — OS package installer (currently only `ubuntu.sh`); skipped when `TERMINAL_SETUP_SKIP_OS_INSTALL=1`
- `README.md` — human-readable description

## Key patterns

- All scripts use `set -euo pipefail`.
- The install flow always backs up before modifying anything.
- `apply_profile_files` renames any existing target file with a `.terminal-setup-backup.<epoch>` suffix before overwriting.
- Environment variables (`TERMINAL_SETUP_HOME`, `TERMINAL_SETUP_BACKUPS_DIR`, `TERMINAL_SETUP_SKIP_OS_INSTALL`, `TERMINAL_SETUP_ASSUME_YES`) control testing/CI behavior — use them to avoid side effects.
