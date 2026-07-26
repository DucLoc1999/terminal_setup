#!/usr/bin/env bash

print_header() {
  printf '\n== %s ==\n' "$1"
}

confirm() {
  local prompt="${1:-Continue?}"
  local answer
  if [[ "${TERMINAL_SETUP_ASSUME_YES:-0}" == "1" ]]; then
    return 0
  fi
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

print_package_plan() {
  local -n _plan_apt=$1
  local -n _plan_brew=$2

  if ((${#_plan_apt[@]})); then
    echo "[apt] Packages: ${_plan_apt[*]}"
  fi
  if ((${#_plan_brew[@]})); then
    echo "[brew] Packages: ${_plan_brew[*]}"
  fi
}
