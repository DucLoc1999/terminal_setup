#!/usr/bin/env bash

load_profile_requirements() {
  local profile_dir="$1"
  local requirements_file="$profile_dir/requirements.sh"
  local HOME="$TARGET_HOME"

  REQUIRED_COMMANDS=()
  REQUIRED_PATHS=()
  REQUIRES_POWERLINE_FONT=0

  if [[ -f "$requirements_file" ]]; then
    # shellcheck disable=SC1090
    source "$requirements_file"
  fi
}

check_command() {
  command -v "$1" >/dev/null 2>&1
}

profile_precheck() {
  local profile_name="$1"
  local profile_dir="$PROFILES_DIR/$profile_name"
  local missing=0
  local item

  load_profile_requirements "$profile_dir"

  print_header "Preflight"
  echo "Profile: $profile_name"

  if ((${#REQUIRED_COMMANDS[@]})); then
    echo "Required commands:"
    for item in "${REQUIRED_COMMANDS[@]}"; do
      if check_command "$item"; then
        echo "  ok  $item"
      else
        echo "  miss $item"
        missing=1
      fi
    done
  fi

  if ((${#REQUIRED_PATHS[@]})); then
    echo "Required paths:"
    for item in "${REQUIRED_PATHS[@]}"; do
      if [[ -e "$item" ]]; then
        echo "  ok  $item"
      else
        echo "  miss $item"
        missing=1
      fi
    done
  fi

  if [[ "${REQUIRES_POWERLINE_FONT:-0}" == "1" ]]; then
    if command -v fc-list >/dev/null 2>&1 && fc-list | grep -qi powerline; then
      echo "  ok  powerline fonts"
    else
      echo "  miss powerline fonts"
      missing=1
    fi
  fi

  echo
  if ((missing)); then
    echo "Some prerequisites are missing. The installer will try to add what it can."
  else
    echo "All prerequisite checks passed."
  fi
}

apply_profile_files() {
  local profile_dir="$1"
  local config_dir="$profile_dir/configs"
  local src
  shopt -s nullglob dotglob

  if [[ ! -d "$config_dir" ]]; then
    echo "Missing configs directory: $config_dir"
    exit 1
  fi

  print_header "Apply Config"
  for src in "$config_dir"/*; do
    local base
    base="$(basename "$src")"
    [[ "$base" == "." || "$base" == ".." ]] && continue

    if [[ -e "$TARGET_HOME/$base" || -L "$TARGET_HOME/$base" ]]; then
      mv "$TARGET_HOME/$base" "$TARGET_HOME/${base}.terminal-setup-backup.$(date +%s)"
    fi

    cp -a "$src" "$TARGET_HOME/$base"
    echo "Installed $base"
  done

  shopt -u nullglob dotglob
}

run_profile_installer() {
  local profile_dir="$1"
  local os_name
  os_name="$(uname -s | tr '[:upper:]' '[:lower:]')"

  if [[ "${TERMINAL_SETUP_SKIP_OS_INSTALL:-0}" == "1" ]]; then
    echo "Skipping OS package install"
    return 0
  fi

  case "$os_name" in
    linux)
      if [[ -x "$profile_dir/install/ubuntu.sh" ]]; then
        bash "$profile_dir/install/ubuntu.sh"
      fi
      ;;
    darwin)
      if [[ -x "$profile_dir/install/macos.sh" ]]; then
        bash "$profile_dir/install/macos.sh"
      fi
      ;;
  esac
}

has_existing_backup() {
  local found=0
  for dir in "$BACKUPS_DIR"/*; do
    [[ -d "$dir" ]] && found=1 && break
  done
  return $((1 - found))
}

install_profile() {
  local profile_name="$1"
  local profile_dir="$PROFILES_DIR/$profile_name"

  if [[ ! -d "$profile_dir" ]]; then
    echo "Profile not found: $profile_name"
    exit 1
  fi

  profile_precheck "$profile_name"

  if [[ "${TERMINAL_SETUP_ASSUME_YES:-0}" != "1" ]]; then
    if ! confirm "Proceed with install and config replacement?"; then
      echo "Install cancelled."
      exit 0
    fi
  fi

  print_header "Install"

  if has_existing_backup; then
    echo "Existing backups found in: $BACKUPS_DIR"
    find_backups | sed 's/^/  /'
    echo
  else
    echo "No existing backups found."
  fi

  if [[ "${TERMINAL_SETUP_ASSUME_YES:-0}" == "1" ]] || confirm "Create a backup of your current state before installing?"; then
    backup_current_state "$profile_name"
  else
    echo "Skipping backup."
  fi

  run_profile_installer "$profile_dir"
  apply_profile_files "$profile_dir"
}
