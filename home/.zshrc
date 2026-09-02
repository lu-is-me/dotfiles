#  _  | \   / |  Luis Meier
# | | |  \_/  |  https://github.com/luismeier
# | | | |\_/| |  https://luismeier.ch
# | |_|_|_  |_|
# |_______|

# For perf measurmenent
# zmodload zsh/zprof # at the top of the file

# ==============================================================================
# ZINIT INITIALIZATION
# ==============================================================================

# Set the directory we want to store zinit and plugins, download if not available
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
unalias zi 2>/dev/null  # free up zi for zoxide

# ==============================================================================
# ENVIRONMENT VARIABLES
# ==============================================================================
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim -c 'Man!'"
# export TERM="xterm-kitty"
# export TERM="xterm-256color"
export BROWSER="firefox"

# follow XDG base dir specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export FZF_DEFAULT_OPTS="--info=default --header-first --layout=reverse "
export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort --no-preview" # separate opts for history widget


# Load my aliases
[ -f "$XDG_CONFIG_HOME/shell/alias" ] && source "$XDG_CONFIG_HOME/shell/alias"

# ==============================================================================
# ZSH PLUGINS
# ==============================================================================
# Syntax highlighting, completions, and suggestions

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit ice wait"0" lucid
zinit light zsh-users/zsh-syntax-highlighting

# Oh My Zsh plugins
zinit snippet OMZP::command-not-found
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::sudo

# Starship prompt
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship


# ==============================================================================
# COMPLETION SYSTEM
# ==============================================================================

# Add docker completions to path
FPATH="$HOME/.docker/completions:$FPATH"

# Completion init
autoload -Uz compinit && compinit
# autoload -Uz promptinit && promptinit
zinit cdreplay -q  # Replay compdefs from cache

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Colored completions
zstyle ':completion:*' menu no  # Disable default menu (use fzf-tab)
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Docker option stacking
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes


# ==============================================================================
# HISTORY CONFIGURATION
# ==============================================================================
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
HISTSIZE=10000
HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
# bindkey -v

setopt globdots
setopt autocd
setopt CORRECT
setopt extended_glob
setopt interactive_comments # Allow for comments

# Open buffer line in EDITOR
# autoload -Uz edit-command-line
# zle -N edit-command-line
# bindkey '^xe' edit-command-line
# bindkey -M vicmd v edit-command-line

# ==============================================================================
# KEYBINDINGS
# ==============================================================================
# Home, End, Delete
bindkey "^[[H"   beginning-of-line
bindkey "^[[F"   end-of-line
bindkey "^[[3~"  delete-char

# History search
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Autosuggestions
bindkey '^ ' autosuggest-accept  # Ctrl-Space to accept

# ==============================================================================
# FZF INITIALIZATION
# ==============================================================================
command -v fzf > /dev/null && eval "$(fzf --zsh)"

# if command -v fzf >/dev/null 2>&1; then
#   if fzf --help 2>&1 | grep -q -- '--zsh'; then
#     eval "$(fzf --zsh)"
#   else
#     # Legacy fallback
#     for f in /usr/share/fzf/shell/{completion,key-bindings}.zsh \
#              /usr/share/doc/fzf/examples/{completion,key-bindings}.zsh; do
#       [ -f "$f" ] && source "$f"
#     done
#   fi
# fi

# PATH configuration

# ==============================================================================
# SHELL INTEGRATIONS
# ==============================================================================
# direnv - must be loaded immediately
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# zoxide - replaces cd, must be loaded immediately
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"



# Kitty fixes
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

# ==============================================================================
# SOurce all my little special scripts
for f in ~/.config/zsh/*.zsh; do source "$f"; done
for f in ~/.config/zsh/*.bash; do source "$f"; done

# For perf mesurmenents
# zprof
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# Fix: uv run doesn't include positional arg completion in generated completions
# Wrap _uv to fall back to file completion for non-flag positional args after 'uv run'
functions[_uv_orig]=${functions[_uv]}
_uv() {
  _uv_orig "$@"
  [[ ${words[2]} == run && ${words[CURRENT]} != -* ]] && _files
}


export INOVITAS_SAVE_FOLDER=/home/luism/projects/artemis/innovitas_data/
export INOVITAS_AUTH_CONFIG_PATH=/home/luism/projects/artemis/innovitas_data/auth_client.json
export PATH="$HOME/.local/bin:$PATH"
