# ==============================================================================
# LOGIN-SHELL ENVIRONMENT
# ==============================================================================
# Sourced by login zsh only. SDDM's /etc/sddm/wayland-session re-execs itself as
# `zsh --login` before `exec start-hyprland`, so this is the last hook that runs
# BEFORE the compositor process starts.
#
# Anything aquamarine (Hyprland's backend) reads while initialising must be set
# here, not in hypr's `env =` / hl.env(): those apply to Hyprland's children,
# after the DRM backend has already enumerated devices.

# GPU order for Hyprland's DRM backend: Intel iGPU first so it is the primary
# render device. The dock's DisplayPort outputs hang off the Intel display
# engine; with the NVIDIA card primary, resume re-allocates their framebuffers
# with an NVIDIA BLOCK_LINEAR_2D modifier that the Intel display engine cannot
# scan out, the atomic modeset fails with EINVAL, and the external monitors
# never light up again. Symlinks come from local/bin/setup-gpu-symlinks.
export AQ_DRM_DEVICES="/dev/dri/intel-igpu:/dev/dri/nvidia-gpu"
