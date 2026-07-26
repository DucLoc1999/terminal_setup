#!/usr/bin/env bash

set -euo pipefail

run_brew() {
  if [[ $EUID -eq 0 ]] || ! command -v sudo >/dev/null 2>&1; then
    "$@"
  else
    sudo "$@"
  fi
}

install_homebrew_if_needed() {
  if command -v brew >/dev/null 2>&1; then
    echo "[brew] Homebrew already installed"
    return 0
  fi

  local brew_bin="/home/linuxbrew/.linuxbrew/bin/brew"
  if [[ -x "$brew_bin" ]]; then
    eval "$("$brew_bin" shellenv)"
    echo "[brew] Homebrew already installed (linuxbrew)"
    return 0
  fi

  echo "[brew] Installing Homebrew..."
  if ! command -v curl >/dev/null 2>&1; then
    echo "curl not found; cannot install Homebrew"
    return 1
  fi

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  eval "$("$brew_bin" shellenv)"
}

install_neovim_via_brew() {
  if command -v nvim >/dev/null 2>&1; then
    local nvim_path
    nvim_path="$(command -v nvim)"
    if [[ "$nvim_path" == *linuxbrew* ]] || [[ "$nvim_path" == *homebrew* ]]; then
      echo "[brew] Neovim already installed"
      return 0
    fi
    echo "[brew] Neovim found at $nvim_path (not brew) — reinstalling via Homebrew"
    run_brew brew install neovim
    return 0
  fi

  echo "[brew] Installing: neovim"
  run_brew brew install neovim
}

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

install_homebrew_if_needed

if ! command -v brew >/dev/null 2>&1; then
  local_brew_bin="/home/linuxbrew/.linuxbrew/bin/brew"
  if [[ -x "$local_brew_bin" ]]; then
    eval "$("$local_brew_bin" shellenv)"
  fi
fi

install_neovim_via_brew
install_oh_my_zsh
install_fzf_tab
set_zsh_as_default