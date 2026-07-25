
# ==============================================================================
# Completion & Plugins
# ==============================================================================

# Load cấu hình fzf-tab (đã bao gồm compinit và load plugin)
if [ -f ~/.config/zsh/fzf.zsh ]; then
    source ~/.config/zsh/fzf.zsh
fi

# ==============================================================================
# Oh My Zsh
# ==============================================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="dst"

plugins=(
	git
	fzf-tab
)

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# User config
# ==============================================================================

# app
export PATH="$HOME/.local/bin:$PATH"

# Home brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# opencode
# export PATH=/home/loc/.opencode/bin:$PATH

# nvim-mason: lsp manager
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

