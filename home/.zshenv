# ==============================================================================
# ENVIRONMENT VARIABLES
# ==============================================================================
# Read by every zsh (login, interactive, scripts), so keep this to exports only.
# TERM is deliberately not set here: the terminal emulator owns it.

export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim -c 'Man!'"
export BROWSER="firefox"

# follow XDG base dir specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export FZF_DEFAULT_OPTS="--info=default --header-first --layout=reverse"
export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort --no-preview" # separate opts for history widget

# Rust toolchain
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
