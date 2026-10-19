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
