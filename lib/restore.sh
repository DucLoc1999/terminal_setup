#!/usr/bin/env bash

restore_backup() {
  local backup_name="$1"
  local backup_dir="$BACKUPS_DIR/$backup_name"
  local src
  shopt -s nullglob dotglob

  if [[ ! -d "$backup_dir" ]]; then
    echo "Backup not found: $backup_name"
    exit 1
  fi

  print_header "Restore"
  if ! confirm "Restore will overwrite files in $TARGET_HOME. Continue?"; then
    echo "Restore cancelled."
    shopt -u nullglob dotglob
    exit 0
  fi

  backup_current_state "before_restore_${backup_name}"

  for src in "$backup_dir"/*; do
    local base
    base="$(basename "$src")"
    [[ "$base" == "." || "$base" == ".." ]] && continue
    cp -a "$src" "$TARGET_HOME/$base"
    echo "Restored $base"
  done

  shopt -u nullglob dotglob
}
