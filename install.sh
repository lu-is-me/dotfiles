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
# Split theming: the dux (dms) shell runs dark, applications run light.
# dux's "sync mode with portal" must be OFF (Settings -> Theme -> Apps), otherwise it pushes its
# dark mode into gsettings color-scheme. Set it over IPC: the running shell rewrites
# settings.json from memory, so editing the file directly gets reverted.
# dux still generates DankMatugenLight from the wallpaper, but it also applies DankMatugen<mode>
# to kdeglobals on every regeneration; kde-apps-light.path (systemd/user) switches it back.
# Qt apps read kdeglobals via QT_QPA_PLATFORMTHEME=kde. kdeglobals isn't linked because KDE
# rewrites it wholesale, so only select the scheme here.
if command -v dms >/dev/null 2>&1 && dms ipc call settings set syncModeWithPortal false >/dev/null 2>&1; then
    echo "  dms: syncModeWithPortal=false"
else
    echo "  SKIP dms portal sync (shell not running) -- turn it off in dux Settings -> Theme -> Apps"
fi
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
    echo "  gsettings: color-scheme=prefer-light"
fi
if "$DOTFILES_DIR/local/bin/kde-apps-light" 2>&1 | sed 's/^/  /'; then
    :
elif command -v kwriteconfig6 >/dev/null 2>&1; then
    kwriteconfig6 --file kdeglobals --group General --key ColorScheme DankMatugenLight
    echo "  kdeglobals: ColorScheme=DankMatugenLight"
else
    echo "  SKIP kdeglobals (kde-apps-light failed and kwriteconfig6 not found)"
fi
for src in "$DOTFILES_DIR/systemd/user"/*; do
    link "$src" "$HOME/.config/systemd/user/$(basename "$src")"
done
if systemctl --user daemon-reload 2>/dev/null && systemctl --user enable --now kde-apps-light.path >/dev/null 2>&1; then
    echo "  systemd: kde-apps-light.path enabled"
else
    echo "  WARN could not enable kde-apps-light.path (systemctl --user enable --now kde-apps-light.path)"
fi

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
