#!/usr/bin/env bash

BACKUP_FILES=(
  ".zshrc"
  ".zprofile"
  ".bashrc"
  ".gitconfig"
)

XDG_TMUX_FILES=(
  ".config/tmux/tmux.conf"
  ".config/tmux/tmux.conf.local"
)

backup_current_state() {
  local label="${1:-manual}"
  local stamp
  local backup_dir

  stamp="$(date +%Y-%m-%d_%H%M%S)"
  backup_dir="$BACKUPS_DIR/${stamp}_${label}"
  mkdir -p "$backup_dir"

  print_header "Backup"
  echo "Saving current state to: $backup_dir"

  for file in "${BACKUP_FILES[@]}"; do
    if [[ -e "$TARGET_HOME/$file" ]]; then
      cp -a "$TARGET_HOME/$file" "$backup_dir/"
      echo "  saved  $file"
    fi
  done

  for file in "${XDG_TMUX_FILES[@]}"; do
    if [[ -e "$TARGET_HOME/$file" ]]; then
      mkdir -p "$backup_dir/tmux"
      cp -a "$TARGET_HOME/$file" "$backup_dir/tmux/"
      echo "  saved  $file"
    fi
  done

  echo
  echo "Backup complete: $backup_dir"
}

remove_backup() {
  local backup_name="$1"
  local backup_dir="$BACKUPS_DIR/$backup_name"

  if [[ ! -d "$backup_dir" ]]; then
    echo "Backup not found: $backup_name"
    exit 1
  fi

  print_header "Remove Backup"
  echo "Backup to remove: $backup_dir"
  if ! confirm "Are you sure you want to permanently delete this backup?"; then
    echo "Remove cancelled."
    exit 0
  fi

  rm -rf "$backup_dir"
  echo "Removed: $backup_dir"
}
