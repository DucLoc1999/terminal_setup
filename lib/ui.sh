#!/usr/bin/env bash

print_header() {
  printf '\n== %s ==\n' "$1"
}

confirm() {
  local prompt="${1:-Continue?}"
  local answer
  read -r -p "$prompt [y/N] " answer
  [[ "$answer" == "y" || "$answer" == "Y" ]]
}

safe_name() {
  printf '%s' "$1" | tr ' ' '_' | tr -cd '[:alnum:]_-.'
}

find_profiles() {
  local found=1
  for dir in "$ROOT_DIR"/profiles/*; do
    [[ -d "$dir" ]] || continue
    found=0
    basename "$dir"
  done
  return "$found"
}

find_backups() {
  local found=1
  for dir in "$BACKUPS_DIR"/*; do
    [[ -d "$dir" ]] || continue
    found=0
    basename "$dir"
  done
  return "$found"
}
