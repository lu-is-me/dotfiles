#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$1"
    local dst="$2"

    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        echo "  SKIP $dst (exists, not a symlink — remove manually to link)"
        return
    fi

    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "  $dst -> $src"
}

echo "Dotfiles: $DOTFILES_DIR"
echo ""

echo "[config]"
for src in "$DOTFILES_DIR/config"/*/; do
    link "$src" "$HOME/.config/$(basename "$src")"
done

echo ""
echo "[local/bin]"
for src in "$DOTFILES_DIR/local/bin"/*; do
    link "$src" "$HOME/.local/bin/$(basename "$src")"
done

echo ""
echo "[home]"
for src in "$DOTFILES_DIR/home"/.*; do
    name="$(basename "$src")"
    [[ "$name" == "." || "$name" == ".." ]] && continue
    link "$src" "$HOME/$name"
done

echo ""
echo "[zsh]"
# zsh won't create these itself: HISTFILE and the compinit dump live here.
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
echo "  created state/cache dirs"

echo ""
echo "[tmux plugins]"
# tmux.conf ends with `run '~/.config/tmux/plugins/tpm/tpm'`, which fails silently if
# tpm is absent. The plugins are gitignored (tpm owns them), so bootstrap it here and
# let tpm install the rest -- in tmux: prefix + I.
TPM_DIR="$DOTFILES_DIR/config/tmux/plugins/tpm"
if [[ -d "$TPM_DIR/.git" ]]; then
    echo "  tpm already present"
elif command -v git >/dev/null 2>&1; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR" \
        && echo "  cloned tpm (run prefix + I in tmux to install the rest)"
else
    echo "  SKIP tpm (git not found)"
fi

echo ""
echo "Done."
