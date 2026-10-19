# Add docker completions to path
FPATH="$HOME/.docker/completions:$FPATH"

# Completion init
autoload -Uz compinit && compinit
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

compinit -d "$XDG_CACHE_HOME/zsh/completion"  # Cache completions for faster startup
