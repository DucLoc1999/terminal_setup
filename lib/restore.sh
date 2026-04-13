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
    local base is_dir relpath
    base="$(basename "$src")"
    [[ "$base" == "." || "$base" == ".." ]] && continue
    [[ -d "$src" ]] && is_dir=1 || is_dir=0

    relpath="$base"
    if [[ "$base" == "tmux" && "$is_dir" -eq 1 ]]; then
      relpath=".config/tmux"
    elif [[ "$base" == "tmux"* && "$is_dir" -eq 0 ]]; then
      relpath=".config/tmux/$base"
    fi

    if [[ "$is_dir" -eq 1 ]]; then
      mkdir -p "$TARGET_HOME/$relpath"
      cp -a "$src/"* "$TARGET_HOME/$relpath/" 2>/dev/null || true
    else
      cp -a "$src" "$TARGET_HOME/$relpath"
    fi
    echo "Restored $relpath"
  done

  shopt -u nullglob dotglob
}
