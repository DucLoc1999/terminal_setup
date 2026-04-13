#!/usr/bin/env bash

set -euo pipefail

if [ ${EUID:-$(id -u)} -eq 0 ]; then
  printf '❌ Do not execute this script as root!\n' >&2 && exit 1
fi

run_apt() {
  if [[ $EUID -eq 0 ]] || ! command -v sudo >/dev/null 2>&1; then
    apt-get "$@"
  else
    sudo apt-get "$@"
  fi
}

if command -v apt-get >/dev/null 2>&1; then
  run_apt update
  run_apt install -y curl bat fzf eza git zsh tmux fonts-powerline
else
  echo "apt-get not found; skipping Ubuntu package install"
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]] && command -v curl >/dev/null 2>&1 && command -v git >/dev/null 2>&1; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if command -v curl >/dev/null 2>&1 && command -v git >/dev/null 2>&1; then
  curl -fsSL "https://github.com/gpakosz/.tmux/raw/refs/heads/master/install.sh" | bash
fi

if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/fzf-tab" ]] && command -v git >/dev/null 2>&1; then
  git clone --depth 1 https://github.com/Aloxaf/fzf-tab "$HOME/.oh-my-zsh/custom/plugins/fzf-tab"
fi
