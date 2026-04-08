#!/usr/bin/env bash

set -euo pipefail

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y zsh tmux bat fzf eza git curl fonts-powerline
else
  echo "apt-get not found; skipping Ubuntu package install"
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]] && command -v curl >/dev/null 2>&1 && command -v git >/dev/null 2>&1; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
