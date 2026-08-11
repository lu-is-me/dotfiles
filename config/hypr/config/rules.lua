-- ── Tags ──────────────────────────────────────────────────────────────────────
hl.window_rule({
	match = { tag = "floating-window" },
	float = true,
	center = true,
	size = { 900, 650 },
})

hl.window_rule({
	match = {
		class = "(btop|blueberry.py|wlctl|bluetui|Wiremix|org.gnome.NautilusPreviewer|com.gabm.satty|Omarchy|About|TUI.float)",
	},
	tag = "+floating-window",
})

hl.window_rule({
	match = {
		class = "(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus)",
		title = "^(Open.*Files?|Open Folder|Save.*Files?|Save.*As|Save|All Files)",
	},
	tag = "+floating-window",
})

-- ── Focus behavior ─────────────────────────────────────────────────────────────
hl.window_rule({
	match = { class = "^(Rofi)" },
	stay_focused = true,
	focus_on_activate = true,
})

-- ── Workspace assignments ──────────────────────────────────────────────────────
hl.window_rule({
	match = { class = "^(org.mozilla.firefox)$" },
	workspace = "1",
})

hl.window_rule({
	match = { class = "^(thunar|org.kde.dolphin|org.gnome.Nautilus)$" },
	workspace = "4",
})

hl.window_rule({
	match = { class = "(?i)^.*(obsidian|logseq).*$" },
	workspace = "7",
})

hl.window_rule({
	match = { class = "^(org.gnome.Evolution|outlook-for-linux)$" },
	workspace = "8",
})

hl.window_rule({
	match = { class = "(?i)^.*(teams).*$" },
	workspace = "9",
})

-- Screen share active window
hl.window_rule({
	match = { class = "(?i)^.*(teams).*$", title = "(?i).*(shared).*$" },
	float = true,
	size = { 1000, 500 },
})

hl.window_rule({
	match = { class = "(?i)^.*(spotify|tidal|signal).*$" },
	workspace = "10",
})

-- ── Common modal dialogs (float) ───────────────────────────────────────────────
hl.window_rule({
	match = { title = "^(Open|Choose Files|Save As|Confirm to replace files|File Operation Progress)$" },
	float = true,
})

hl.window_rule({
	match = { class = "^(google-chrome)$", title = "^(Open File)$" },
	float = true,
})

-- ── Floating + centered dialogs ────────────────────────────────────────────────
hl.window_rule({
	match = { class = "^(nm-openconnect-auth-dialog)$" },
	float = true,
	center = true,
})

hl.window_rule({
	match = { class = "^(org.kde.kcalc|org.gnome.Calculator)$" },
	float = true,
	center = true,
})

hl.window_rule({
	match = { class = "(?i)^.*nextcloud.*$" },
	float = true,
	center = true,
	stay_focused = true,
	pin = true,
})

hl.window_rule({
	match = { class = "^(evolution-alarm-notify)$" },
	float = true,
	center = true,
})

hl.window_rule({
	match = { class = "^(blueman-manager|bluetui)$" },
	float = true,
	center = true,
})

-- ── impala (override tag size since it needs different dimensions) ─────────────
hl.window_rule({
	match = { class = "(?i)^(impala)$" },
	float = true,
	center = true,
	size = { 950, 600 },
})

-- ── KiCad ─────────────────────────────────────────────────────────────────────
hl.window_rule({
	match = { class = "^(KiCad)$" },
	workspace = "3",
})

hl.window_rule({
	match = { class = "^(KiCad)$", title = "^.*Properties.*$" },
	float = true,
})

-- ── FreeCAD ───────────────────────────────────────────────────────────────────
hl.window_rule({
	match = { class = "^(FreeCAD)$" },
	suppress_event = "maximize activatefocus",
	no_initial_focus = true,
	stay_focused = false,
})

hl.window_rule({
	match = { class = "^(FreeCAD)$", title = "^.*Preferences.*$" },
	float = true,
	no_initial_focus = true,
})

-- ── hyprland-run ──────────────────────────────────────────────────────────────
hl.window_rule({
	match = { class = "^(hyprland-run)$" },
	float = true,
	move = "20 monitor_h-120",
})

-- ── Global rules ──────────────────────────────────────────────────────────────
hl.window_rule({
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- Noctalia Settings
hl.layer_rule({
	match = { namespace = "noctalia-background-.*$" },
	ignore_alpha = 0.5,
	blur = true,
	blur_popups = true,
})

hl.window_rule({
	match = { class = "dev.noctalia.Noctalia" },
	float = true,
	size = { 1080, 920 },
})

-- ── Commented out (kept for reference) ────────────────────────────────────────
-- hl.window_rule({
--     match            = { class = "^(xwaylandvideobridge)$" },
--     opacity          = "0.0 override",
--     no_anim          = true,
--     no_initial_focus = true,
--     max_size         = { 1, 1 },
--     no_blur          = true,
--     no_focus         = true,
-- })
