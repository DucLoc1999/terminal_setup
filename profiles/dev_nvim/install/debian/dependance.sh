#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

source "$SOURCE_DIR/dependencies.conf" 2>/dev/null || true

run_apt() {
  if [[ $EUID -eq 0 ]] || ! command -v sudo >/dev/null 2>&1; then
    apt-get "$@"
  else
    sudo apt-get "$@"
  fi
}

install_dependencies_debian() {
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "apt-get not found; skipping Debian package install"
    return 0
  fi

  if [[ -v debian_packages[@] ]]; then
    local missing=()
    for pkg in "${debian_packages[@]}"; do
      if ! dpkg -l "$pkg" >/dev/null 2>&1; then
        missing+=("$pkg")
      fi
    done

    if ((${#missing[@]} > 0)); then
      echo "Installing missing packages: ${missing[*]}"
      run_apt update
      run_apt install -y "${missing[@]}"
    else
      echo "All Debian dependencies already installed"
    fi
  else
    echo "debian_packages not defined; skipping"
  fi
}

install_dependencies_debian