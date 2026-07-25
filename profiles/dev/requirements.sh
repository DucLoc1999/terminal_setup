#!/usr/bin/env bash

# ── Canonical package names (documentation) ──
#   curl, git, zsh, tmux, bat, fzf, eza

# ── OS-specific dependency lists ──
DEPENDANCE_DEBIAN=(curl git zsh tmux bat fzf eza fonts-powerline build-essential procps file)
DEPENDANCE_RHEL=(curl git zsh tmux bat fzf eza powerline-fonts @development-tools procps-ng file)

# ── Preflight checks ──
REQUIRED_COMMANDS=(curl zsh tmux batcat fzf eza git)
REQUIRED_PATHS=("$HOME/.oh-my-zsh")
REQUIRES_POWERLINE_FONT=1