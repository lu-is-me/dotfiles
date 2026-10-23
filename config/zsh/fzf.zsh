# =========================================================
# fzf
# =========================================================

# Ubuntu (e.g. ROS distroboxes) ships fd/bat as fdfind/batcat
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'  # strip-cwd-prefix removes the leading ./ from results
elif command -v fdfind >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --strip-cwd-prefix'
else
  unset FZF_DEFAULT_COMMAND  # may be inherited from the host via distrobox
fi

# Ctrl-T uses fd
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# UI
export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt="  "
  --pointer="  "
  --preview-window=right:65%:wrap:border-left
'

if command -v bat >/dev/null 2>&1; then
  export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
elif command -v batcat >/dev/null 2>&1; then
  export _FZF_PREVIEW_CMD='batcat --color=always --style=plain,numbers --line-range=:500 {}'
else
  export _FZF_PREVIEW_CMD='head -n 500 {}'
fi
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"

# Ctrl+F: file picker excluding hidden files
_fzf_file_no_hidden() {
  local cmd result
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  result=$(eval "${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") \
    && LBUFFER+="$result"  # LBUFFER is the text left of the cursor
  zle reset-prompt
}
zle -N _fzf_file_no_hidden
bindkey '^F' _fzf_file_no_hidden

# Official keybindings (Ctrl-R, Ctrl-T, Alt-C) and ** completion.
# `fzf --zsh` needs fzf >= 0.48; older distro packages (Ubuntu 24.04 has 0.44)
# ship the same scripts as files instead.
_fzf_load_integration() {
  local init dir
  if init="$(fzf --zsh 2>/dev/null)" && [[ -n $init ]]; then
    eval "$init"
    return
  fi
  for dir in /usr/share/doc/fzf/examples /usr/share/fzf/shell /usr/share/fzf; do
    [[ -f $dir/key-bindings.zsh ]] || continue
    source "$dir/key-bindings.zsh"
    [[ -f $dir/completion.zsh ]] && source "$dir/completion.zsh"
    return
  done
  print -u2 "fzf.zsh: no zsh integration found for $(fzf --version)"
}
command -v fzf >/dev/null 2>&1 && _fzf_load_integration
unfunction _fzf_load_integration
