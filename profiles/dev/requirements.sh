#!/usr/bin/env bash

# Required terminal tools for the dev profile.
REQUIRED_COMMANDS=(
  zsh
  tmux
  bat
  fzf
  eza
  git
  curl
)

# Files or directories that should exist after install.
REQUIRED_PATHS=(
  "$HOME/.oh-my-zsh"
)

# Powerline glyphs are needed for the profile's font setup.
REQUIRES_POWERLINE_FONT=1

