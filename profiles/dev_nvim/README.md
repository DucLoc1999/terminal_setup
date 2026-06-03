# dev

General-purpose developer shell profile.

## Includes

| Tool | Description | Config | Doc |
|------|-------------|--------|-----|
| `zsh` (oh-my-zsh) | Shell with completion | `~/.zshrc` | [ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh/tree/master) |
| `tmux` (oh-my-tmux) | Terminal multiplexer | `~/.tmux.conf.local` | [gpakosz/.tmux](https://github.com/gpakosz/.tmux/tree/master) |
| `fzf` | Fuzzy finder | — | [junegunn/fzf](https://github.com/junegunn/fzf) |
| `fzf-tab` | fzf-powered tab completion | `~/.zshrc` | [Aloxaf/fzf-tab](https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file) |
| `bat` | `cat` with syntax highlighting | — | — |
| `eza` | Modern `ls` | — | — |

## Install flow

1. Back up current shell state
2. Run preflight checks for commands, paths, and fonts
3. Ask for confirmation before install
4. Run OS package installer if present
5. Copy profile configs into `$HOME`

## Keybindings

### tmux popup
- Prefix key: `Ctrl + z` (instead of default `Ctrl + b`)
- `Ctrl + z` + `d` → detach
- `Ctrl + z` + `p` → paste from buffer
- `Ctrl + z` + `shift + p` → choose from buffer to paste
- `Ctrl + z` + `c` → new window
- `Ctrl + z` + `]` → split vertically
- `Ctrl + z` + `\` → split horizontally

### fzf / tmux popup preview
- `Ctrl + j` / `Ctrl + k` → scroll preview down/up (line by line)
- `Shift + ↑` / `↓` or `mouse wheel` → scroll (depends on terminal)
- Arrow keys → scroll in tmux popup (tmux v3.2+)

## Usage Examples

### Basic
```bash
cd ~/dev    # Tab to complete path use arrow keys to navigate
ls          # Tab to list with eza preview in fzf-tab use arrow keys to navigate
nano ~/.z   # Tab to complete, shows file list with bat preview use arrow keys to navigate
```

### With tmux
```bash
tmux new -s dev    # create new session then use as usual
```