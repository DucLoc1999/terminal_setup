# Terminal Setup

Profile-based terminal configuration manager for `zsh`, `tmux`, and related tools.

## Layout

```text
terminal-setup/
  bin/
    terminal-setup.sh
  lib/
    backup.sh
    install.sh
    restore.sh
    ui.sh
  profiles/
    dev/
      README.md
      configs/
        .zshrc
        .tmux.conf
      install/
        ubuntu.sh
  backups/
```

## What it does

- Backs up the current terminal state into `backups/<timestamp>/`
- Installs a selected profile by backing up first, then copying or linking configs
- Lets you restore a previous backup
- Supports safe testing with `TERMINAL_SETUP_HOME`, `TERMINAL_SETUP_BACKUPS_DIR`, and `TERMINAL_SETUP_SKIP_OS_INSTALL`

## Recommended naming

- Use `profiles/` instead of `theme_1/`
- Use `profile.md` or `README.md` for the profile description
- Use `install/` for OS-specific package setup scripts
- Use `backups/` for captured local machine state
