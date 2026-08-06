-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- fix for scaling since hypr update
config.dpi = 96.0

-- For example, changing the color scheme:
config.color_scheme_dirs = { "/home/luism/.config/wezterm/colors" }
-- config.color_scheme = "Tokyo Night"
-- config.color_scheme = "catppuccin-macchiato"
config.color_scheme = "nordfox"
-- config.color_scheme = "nightfox"

-- config.font = wezterm.font("Fira Code NerdFont mono")
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 12

config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.automatically_reload_config = true
-- and finally, return the configuration to wezterm
return config
