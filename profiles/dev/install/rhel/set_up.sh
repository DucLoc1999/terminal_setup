#!/usr/bin/env bash

set -euo pipefail

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "oh-my-zsh already installed"
    return 0
  fi

  echo "Installing oh-my-zsh..."
  if command -v curl >/dev/null 2>&1 && command -v git >/dev/null 2>&1; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

install_fzf_tab() {
  if [[ -d "$HOME/.oh-my-zsh/custom/plugins/fzf-tab" ]]; then
    echo "fzf-tab already installed"
    return 0
  fi

  echo "Installing fzf-tab..."
  if command -v git >/dev/null 2>&1; then
    git clone --depth 1 https://github.com/Aloxaf/fzf-tab "$HOME/.oh-my-zsh/custom/plugins/fzf-tab"
  fi
}

set_zsh_as_default() {
  local zsh_path
  zsh_path="$(command -v zsh 2>/dev/null)" && [[ -n "$zsh_path" ]] || return 0

  local current_shell
  current_shell="$(getent passwd "$(id -un)")" && current_shell="${current_shell##*:}" || return 0

  if [[ "${current_shell##*/}" == "zsh" ]]; then
    echo "zsh is already the default shell"
    return 0
  fi

  echo "Setting zsh as default shell..."
  if [[ $EUID -eq 0 ]]; then
    chsh -s "$zsh_path"
  elif command -v sudo >/dev/null 2>&1; then
    sudo chsh -s "$zsh_path"
  else
    echo "Cannot change shell: no sudo available"
  fi
}

install_oh_my_zsh
install_fzf_tab
set_zsh_as_default