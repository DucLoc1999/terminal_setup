#!/usr/bin/env bash

BACKUP_FILES=(
  ".zshrc"
  ".zprofile"
  ".bashrc"
  ".tmux.conf"
  ".gitconfig"
)

backup_current_state() {
  local label="${1:-manual}"
  local stamp
  local backup_dir

  stamp="$(date +%Y-%m-%d_%H%M%S)"
  backup_dir="$BACKUPS_DIR/${stamp}_${label}"
  mkdir -p "$backup_dir"

  print_header "Backup"
  echo "Saving current state from $TARGET_HOME to $backup_dir"

  for file in "${BACKUP_FILES[@]}"; do
    if [[ -e "$TARGET_HOME/$file" ]]; then
      cp -a "$TARGET_HOME/$file" "$backup_dir/"
      echo "Saved $file"
    fi
  done
}
