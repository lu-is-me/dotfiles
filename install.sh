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
echo "[theme]"
# dux (dms) owns app theming: it switches gsettings gtk-theme between adw-gtk3/adw-gtk3-dark
# and color-scheme with its light/dark mode, and generates the DankMatugen KDE colour scheme
# that Qt apps read via QT_QPA_PLATFORMTHEME=kde. Only point kdeglobals at that scheme here;
# kdeglobals isn't linked because KDE rewrites it wholesale.
if ! ls /usr/share/themes/adw-gtk3 ~/.local/share/themes/adw-gtk3 >/dev/null 2>&1; then
    echo "  WARN adw-gtk3 not installed (dnf install adw-gtk3-theme) -- dux GTK theming needs it"
fi
if command -v kwriteconfig6 >/dev/null 2>&1; then
    kwriteconfig6 --file kdeglobals --group General --key ColorScheme DankMatugen
    echo "  kdeglobals: ColorScheme=DankMatugen"
else
    echo "  SKIP kdeglobals (kwriteconfig6 not found)"
fi
echo "  then: dux Settings -> Theme -> Apps -> Apply GTK / Apply Qt (once)"

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
