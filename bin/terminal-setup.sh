#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_DIR="$ROOT_DIR/lib"
PROFILES_DIR="$ROOT_DIR/profiles"
BACKUPS_DIR="${TERMINAL_SETUP_BACKUPS_DIR:-$ROOT_DIR/backups}"
TARGET_HOME="${TERMINAL_SETUP_HOME:-$HOME}"

source "$LIB_DIR/ui.sh"
source "$LIB_DIR/backup.sh"
source "$LIB_DIR/install.sh"
source "$LIB_DIR/restore.sh"

usage() {
  cat <<'EOF'
Usage:
  terminal-setup.sh list
  terminal-setup.sh backup [-rm] [label]
  terminal-setup.sh install <profile>
  terminal-setup.sh restore <backup-name>

Commands:
  list             Show available profiles and backups
  backup           manage backups: save the current terminal state into backups/ (default: manual), or remove a backup (-rm)
  install          Backup current state, install dependencies, then apply a profile
  restore          Restore a previously saved backup
EOF
}

list_profiles() {
  print_header "Profiles"
  if ! find_profiles; then
    echo "No profiles found in $PROFILES_DIR"
  fi
  print_header "Backups"
  if ! find_backups; then
    echo "No backups found in $BACKUPS_DIR"
  fi
}

exec_shell() {
  if [[ -n "$SHELL" && -x "$SHELL" ]]; then
    if [[ "${TERMINAL_SETUP_SKIP_EXEC_SHELL:-0}" != "1" ]]; then
      echo
      echo "Spawning new shell..."
      exec "$SHELL"
    fi
  fi
}

main() {
  mkdir -p "$BACKUPS_DIR"

  if [[ $# -lt 1 ]]; then
    usage
    exit 1
  fi

  case "$1" in
    list)
      list_profiles
      ;;
    backup)
      shift
      if [[ $# -gt 0 && "$1" == "-rm" ]]; then
        shift
        if [[ $# -lt 1 ]]; then
          echo "Missing backup name."
          usage
          exit 1
        fi
        remove_backup "$1"
      else
        backup_current_state "${1:-manual}"
      fi
      ;;
    install)
      shift
      if [[ $# -lt 1 ]]; then
        echo "Missing profile name."
        usage
        exit 1
      fi
      install_profile "$1"
      exec_shell
      ;;
    restore)
      shift
      if [[ $# -lt 1 ]]; then
        echo "Missing backup name."
        usage
        exit 1
      fi
      restore_backup "$1"
      ;;
    *)
      usage
      exit 1
      ;;
  esac
}

main "$@"
