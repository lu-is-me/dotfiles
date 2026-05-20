hl.env("GDK_BACKEND", "wayland,x11,*") -- GTK use wayland, fallback to x11
hl.env("QT_QPA_PLATFORM", "wayland;xcb") -- Same for Qt apps
hl.env("SDL_VIDEODRIVER", "wayland")

-- Explicitly set XDG desktop session things
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- hl.env("GTK_THEME", "Adwaita:dark")

-- Cursor setting
hl.env("HYPRCURSOR_THEME", "BreezeX-Black")
hl.env("HYPRCURSOR_SIZE", "28")
hl.env("CURSOR_SIZE", "28")
hl.env("XCURSOR_THEME", "BreezeX-Black")

-- env = XCURSOR_THEME,breeze_cursors
-- env = HYPRCURSOR_THEME,breeze_cursors
-- env = XCURSOR_SIZE,24

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- hl.env("QT_QPA_PLATFORMTHEME", "kde")

-- Electorn apps
-- NOTE: This breaks some flatpak apps.
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- NVIDIA
-- env = WLR_DRM_DEVICES,/dev/dri/intel-igpu:/dev/dri/nvidia-gpu
hl.env("AQ_DRM_DEVICES", "/dev/dri/intel-igpu:/dev/dri/nvidia-gpu")

-- NOTE: These were reccomended settings by hyper but fuck things up on my end
-- hl.env("LIBVA_DRIVER_NAME","nvidia")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME","nvidia")

hl.env("NVD_BACKEND", "direct") -- Should enable VA-API hw video acceleration
