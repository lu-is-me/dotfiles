# ==============================================================================
# COMPLETION SYSTEM
# ==============================================================================
# Sourced from .zshrc AFTER every plugin that adds to fpath, and BEFORE fzf-tab
# and the widget-wrapping plugins (autosuggestions, syntax highlighting).

# Completion init (single run, dump kept out of $ZDOTDIR)
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
zinit cdreplay -q  # Replay compdefs captured from plugins loaded before compinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Colored completions
zstyle ':completion:*' menu no  # Disable default menu (use fzf-tab)
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
