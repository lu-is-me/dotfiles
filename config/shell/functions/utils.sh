# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================
# Shared by bash and zsh: keep to syntax both understand.

# Force applications to run under X11 (useful on Wayland)
# Subshell so unsetting WAYLAND_DISPLAY (how winit >= 0.29 picks X11) stays local
xrun() {
  (
    unset WAYLAND_DISPLAY
    GDK_BACKEND=x11 \
      QT_QPA_PLATFORM=xcb \
      SDL_VIDEODRIVER=x11 \
      _JAVA_AWT_WM_NONREPARENTING=1 \
      "$@"
  )
}

# Make directory and cd into it
mkcd() {
  if [ -z "$1" ]; then
    echo "Usage: mkcd <directory>" >&2
    return 1
  fi
  mkdir -p -- "$1" && cd -- "$1"
}

# Universal archive extractor
extract() {
  if [ -z "$1" ]; then
    cat >&2 << 'EOF'
Usage: extract <archive_file> [archive_file_2] [...]
Supported formats:
  tar, tar.bz2, tar.gz, tar.xz, tbz2, tgz, txz
  zip, rar, 7z, gz, bz2, xz, lzma, cpio
EOF
    return 1
  fi

  local archive lower rc=0
  for archive in "$@"; do
    if [ ! -f "$archive" ]; then
      echo "extract: '$archive' - file does not exist" >&2
      rc=1
      continue
    fi

    lower=$(printf '%s' "$archive" | tr '[:upper:]' '[:lower:]')
    case "$lower" in
      *.tar.bz2|*.tbz2|*.tar.gz|*.tgz|*.tar.xz|*.txz|*.tar)
        tar xvf "$archive" ;;
      *.bz2)
        bunzip2 "$archive" ;;
      *.gz)
        gunzip "$archive" ;;
      *.zip|*.epub|*.cbz)
        unzip "$archive" ;;
      *.rar|*.cbr)
        if ! command -v unrar >/dev/null 2>&1; then
          echo "extract: unrar not installed" >&2
          rc=1
          continue
        fi
        unrar x -ad "$archive" ;;
      *.7z|*.cb7)
        if ! command -v 7z >/dev/null 2>&1; then
          echo "extract: 7z not installed" >&2
          rc=1
          continue
        fi
        7z x "$archive" ;;
      *.xz)
        unxz "$archive" ;;
      *.lzma)
        unlzma "$archive" ;;
      *.cpio)
        cpio -id < "$archive" ;;
      *)
        echo "extract: '$archive' - unknown archive format" >&2
        rc=1
        continue ;;
    esac || rc=1
  done
  return "$rc"
}
