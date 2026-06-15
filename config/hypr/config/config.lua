hl.config({
	input = {
		kb_layout = "ch,us",
		kb_variant = "de",
		kb_model = "",
		kb_options = "grp:shifts_toggle",
		kb_rules = "",
		follow_mouse = 2,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
			clickfinger_behavior = true,
		},
	},
	xwayland = { force_zero_scaling = true },

	general = {
		gaps_in = 2,
		gaps_out = 2,
		border_size = 3,
		col = {
			active_border = "rgba(89dcebee)",
			inactive_border = "rgba(595959aa)",
		},

		layout = "master",
		allow_tearing = false,
		resize_on_border = true,
		extend_border_grab_area = 15,
	},

	decoration = {
		rounding = 0,
		rounding_power = 0,
		active_opacity = 1.0,
		inactive_opacity = 0.95,
		fullscreen_opacity = 1.0,
		blur = {
			enabled = true,
			size = 8,
			passes = 1,
			xray = false,
			popups = true,
			popups_ignorealpha = 0.2,
		},
		shadow = {
			enabled = true,
			render_power = 3,
			color = "rgba(1a1a1aee)",
			range = 2,
		},
	},

	dwindle = {
		preserve_split = true,
		force_split = 2,
		default_split_ratio = 1.1,
	},

	master = {
		new_status = "slave",
		new_on_top = true,
		orientation = "left",
		mfact = 0.6,
	},

	group = {
		groupbar = {
			enabled = true,
			font_family = "JetBrainsMono Nerd Font",
			font_size = 13,
		},
	},

	misc = {
		force_default_wallpaper = 0,
		enable_swallow = false,
		swallow_regex = "^(Alacritty|kitty|wezterm)$",
		focus_on_activate = true,
		anr_missed_pings = 50,
	},

	cursor = {
		no_hardware_cursors = 1, -- 2: auto
	},

	render = {
		direct_scanout = false,
	},
})
