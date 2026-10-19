#  _  | \   / |  Luis Meier
# | | |  \_/  |  https://github.com/luismeier
# | | | |\_/| |  https://luismeier.ch
# | |_|_|_  |_|
# |_______|

# ==============================================================================
# HISTORY CONFIGURATION
# ==============================================================================
HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

setopt GLOBDOTS
setopt AUTOCD
# setopt CORRECT # Enable spelling correction
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS # Allow for comments
setopt NUMERIC_GLOB_SORT # sort file 10 after file9 not file1

# Escape a deleted cwd (e.g. a removed git worktree inherited from the tmux
# server): PWD becomes "." and zsh-syntax-highlighting's path loop spins forever.
[[ $PWD == /* && -d $PWD ]] || builtin cd ~

# ==============================================================================
# ZINIT INITIALIZATION
# ==============================================================================

# Set the directory we want to store zinit and plugins, download if not available
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

unalias zi 2>/dev/null  # free up zi (zinit) for zoxide

# Environment variables live in ~/.zshenv
typeset -U path fpath  # drop duplicate PATH/FPATH entries
path=("$HOME/.local/bin" $path)

# Load my aliases
[ -f "$XDG_CONFIG_HOME/shell/alias" ] && source "$XDG_CONFIG_HOME/shell/alias"

# ==============================================================================
# ZSH PLUGINS
# ==============================================================================
# Syntax highlighting, completions, and suggestions

zinit ice blockf
zinit light zsh-users/zsh-completions # Additional completion definitions for zsh
zinit light zsh-users/zsh-autosuggestions # Suggest commands as you type based on history and completions
zinit light Aloxaf/fzf-tab # FZF-powered tab completion
zinit light z-shell/F-Sy-H # Feature rich syntax highlighting
zinit snippet OMZL::async_prompt.zsh # Non-blocking git status in prompt

# zinit ice wait"0" lucid
# zinit light zsh-users/zsh-syntax-highlighting

# Oh My Zsh plugins
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::sudo # press escape twice to run last command with sudo
zinit snippet OMZP::direnv # autoload direnv integration

# Starship prompt
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship


# ==============================================================================
# FZF INITIALIZATION
# ==============================================================================
command -v fzf > /dev/null && eval "$(fzf --zsh)"

# ==============================================================================
# SHELL INTEGRATIONS
# ==============================================================================

# zoxide - replaces cd, must be loaded immediately
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# Kitty fixes
[ "$TERM" = "xterm-kitty" ] && command -v kitten >/dev/null && alias ssh="kitten ssh"

# ==============================================================================
# Source all my little special scripts
# for f in ~/.config/zsh/*.zsh(N); do source "$f"; done


source "$ZDOTDIR/autocompletion.zsh"
source "$ZDOTDIR/keybinds.zsh"
# source "$ZDOTDIR/fzf.zsh"

