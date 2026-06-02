#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="${HOME}/Pictures/wallpapers"
STATE_LINK="${HOME}/.config/current_wallpaper"
TRANSITION="${TRANSITION:-grow}" # fade|wipe|wave|grow|outer|random|none
TRANSITION_DURATION="${TRANSITION_DURATION:-1}"
TRANSITION_FPS="${TRANSITION_FPS:-60}"

# Wait for awww-daemon to be ready
echo "Waiting for awww-daemon to be ready..."
timeout_s=30
for ((i = 0; i < timeout_s; i++)); do
  if awww query &>/dev/null; then
    break
  fi
  sleep 1
done

if ! awww query &>/dev/null; then
  echo "ERROR: awww-daemon is not running after ${timeout_s}s."
  exit 1
fi

if [[ ! -d "${WALLPAPER_DIR}" ]]; then
  echo "ERROR: wallpaper dir not found: ${WALLPAPER_DIR}"
  exit 1
fi

# Determine current wallpaper from state link
CURRENT_WALL=""
if [[ -L "${STATE_LINK}" ]]; then
  CURRENT_WALL="$(readlink -f "${STATE_LINK}" || true)"
fi

# Fallback: query awww for the currently loaded image
if [[ -z "${CURRENT_WALL}" ]]; then
  CURRENT_WALL="$(awww query 2>/dev/null | grep -Eo '(/[^ ]+\.(png|jpg|jpeg))' | head -n 1 || true)"
fi

echo -e "Current wallpaper:\n  ${CURRENT_WALL:-<unknown>}"

# Pick a random wallpaper different from CURRENT_WALL
if [[ -n "${CURRENT_WALL}" ]] && [[ -f "${CURRENT_WALL}" ]]; then
  WALLPAPER="$(
    find "${WALLPAPER_DIR}" -type f \
      \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) \
      ! -samefile "${CURRENT_WALL}" -print0 |
      shuf -z -n 1 | tr -d '\0'
  )"
else
  WALLPAPER="$(
    find "${WALLPAPER_DIR}" -type f \
      \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -print0 |
      shuf -z -n 1 | tr -d '\0'
  )"
fi

if [[ -z "${WALLPAPER}" ]]; then
  echo "ERROR: No wallpapers found in ${WALLPAPER_DIR}"
  exit 1
fi

echo -e "New wallpaper:\n  ${WALLPAPER}"

awww img "${WALLPAPER}" \
  --transition-type "${TRANSITION}" \
  --transition-duration "${TRANSITION_DURATION}" \
  --transition-fps "${TRANSITION_FPS}"

# Persist for next run
ln -sf "${WALLPAPER}" "${STATE_LINK}"
