# ~/.zshenv - bootstrap only.
#
# zsh reads this before anything else (after /etc/zshenv). Its only job is to point
# ZDOTDIR at the real config; zsh then reads .zprofile/.zshrc/.zlogin from there.
# zsh does NOT re-read $ZDOTDIR/.zshenv after ZDOTDIR changes, so source it here.
#
# Tools that inject themselves via ZDOTDIR (kitty shell integration, VS Code) skip this
# file, restore ZDOTDIR themselves and source $ZDOTDIR/.zshenv directly. That works
# because nothing in /etc/zshenv overwrites ZDOTDIR any more.

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
[[ -r "$ZDOTDIR/.zshenv" ]] && source "$ZDOTDIR/.zshenv"
