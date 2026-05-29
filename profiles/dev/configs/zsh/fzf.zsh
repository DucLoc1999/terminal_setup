# ==============================================================================
# FZF-TAB CONFIGURATION (~/.config/zsh/fzf.zsh)
# ==============================================================================

autoload -U compinit; compinit

# Force hidden files (dotfiles)
setopt GLOB_DOTS

# Completion display
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' insert-tab false
zstyle ':completion:*' menu select

# fzf-tab global keybinds and behavior
zstyle ':fzf-tab:*' fzf-flags \
  --bind="right:accept" \
  --bind="left:abort" \
  --bind="tab:down" \
  --bind="shift-tab:up"

zstyle ':fzf-tab:*' continuous-trigger 'right'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# cd: inline popup with eza preview
zstyle ':fzf-tab:complete:cd:*' fzf-command fzf-tmux -w 50 --
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1a --color=always "$realpath" || ls -1a --color=always "$realpath"'

# nano: floating popup with bat preview
zstyle ':fzf-tab:complete:nano:*' fzf-command fzf-tmux -p 90%,80% -- --preview-window='right:75%'
zstyle ':fzf-tab:complete:nano:*' fzf-preview 'batcat --color=always "$realpath" 2>/dev/null || cat "$realpath"'

# Load fzf-tab (Phải nằm SAU zstyles)
source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab/fzf-tab.plugin.zsh
