#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

source "$SOURCE_DIR/dependencies.conf" 2>/dev/null || true

run_yum() {
  if [[ $EUID -eq 0 ]] || ! command -v sudo >/dev/null 2>&1; then
    "$@"
  else
    sudo "$@"
  fi
}

install_dependencies_rhel() {
  local pkg_manager
  if command -v dnf >/dev/null 2>&1; then
    pkg_manager=dnf
  elif command -v yum >/dev/null 2>&1; then
    pkg_manager=yum
  else
    echo "dnf/yum not found; skipping RHEL package install"
    return 0
  fi

  if [[ -v rhel_packages[@] ]]; then
    local missing=()
    for pkg in "${rhel_packages[@]}"; do
      if ! rpm -q "$pkg" >/dev/null 2>&1; then
        missing+=("$pkg")
      fi
    done

    if ((${#missing[@]} > 0)); then
      echo "[$pkg_manager] Installing: ${missing[*]}"
      run_yum $pkg_manager install -y "${missing[@]}"
    else
      echo "[$pkg_manager] All dependencies already installed"
    fi
  else
    echo "rhel_packages not defined; skipping"
  fi

  if rpm -q neovim >/dev/null 2>&1; then
    echo "[$pkg_manager] neovim detected from $pkg_manager — removing in favor of Homebrew"
    run_yum $pkg_manager remove -y neovim
  fi
}

install_dependencies_rhel