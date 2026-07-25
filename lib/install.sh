#!/usr/bin/env bash

load_profile_requirements() {
  local profile_dir="$1"
  local conf_file="$profile_dir/dependencies.conf"
  local requirements_file="$profile_dir/requirements.sh"
  local HOME="$TARGET_HOME"

  REQUIRED_COMMANDS=()
  REQUIRED_PATHS=()
  REQUIRES_POWERLINE_FONT=0

  if [[ -f "$conf_file" ]]; then
    source "$conf_file"
    REQUIRED_COMMANDS=("${preflight_commands[@]}")
    REQUIRED_PATHS=("${preflight_paths[@]}")
    REQUIRES_POWERLINE_FONT="${preflight_powerline_font:-0}"
  elif [[ -f "$requirements_file" ]]; then
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
  local config_dir="$profile_dir/user_home"
  local src
  shopt -s nullglob dotglob

  if [[ ! -d "$config_dir" ]]; then
    echo "Missing configs directory: $config_dir"
    exit 1
  fi

  print_header "Apply Config"
  for src in "$config_dir"/*; do
    local base relpath
    base="$(basename "$src")"
    [[ "$base" == "." || "$base" == ".." ]] && continue

    relpath="${src#$config_dir/}"

    if [[ -e "$TARGET_HOME/$relpath" || -L "$TARGET_HOME/$relpath" ]]; then
      mv "$TARGET_HOME/$relpath" "$TARGET_HOME/${relpath}.terminal-setup-backup.$(date +%s)"
    fi

    if [[ -d "$src" ]]; then
      mkdir -p "$(dirname "$TARGET_HOME/$relpath")"
    fi
    cp -a "$src" "$TARGET_HOME/$relpath"
    echo "Installed $relpath"
  done

  shopt -u nullglob dotglob
}

detect_os_family() {
  if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "${ID_LIKE:-}" == *debian* ]] || [[ "${ID:-}" == debian ]]; then echo "debian"; return; fi
    if [[ "${ID_LIKE:-}" == *rhel* ]] || [[ "${ID_LIKE:-}" == *fedora* ]] || [[ "${ID:-}" == rhel ]] || [[ "${ID:-}" == fedora ]]; then echo "rhel"; return; fi
    if [[ "${ID_LIKE:-}" == *centos* ]] || [[ "${ID:-}" == centos ]]; then echo "rhel"; return; fi
    if [[ "${ID:-}" == arch ]] || [[ "${ID_LIKE:-}" == *arch* ]]; then echo "arch"; return; fi
  fi
  if command -v apt-get >/dev/null 2>&1; then echo "debian"; return; fi
  if command -v dnf >/dev/null 2>&1 || command -v yum >/dev/null 2>&1; then echo "rhel"; return; fi
  echo "unknown"
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
      local family
      family="$(detect_os_family)"
      echo "Detected OS family: $family"

      load_profile_requirements "$profile_dir"

      if [[ -x "$profile_dir/install/$family/dependance.sh" ]]; then
        echo "Running dependency installer for $family..."
        bash "$profile_dir/install/$family/dependance.sh"
      else
        echo "No dependance.sh found for family: $family"
      fi

      if [[ -x "$profile_dir/install/$family/set_up.sh" ]]; then
        echo "Running setup installer for $family..."
        bash "$profile_dir/install/$family/set_up.sh"
      else
        echo "No set_up.sh found for family: $family"
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
