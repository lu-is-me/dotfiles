hl.on("hyprland.start", function()
	local cmds = {
		-- Desktop portal, this should autostart but does not when not uwsm
		"/usr/libexec/xdg-desktop-portal",
		-- Notification daemon
		-- "swaync",
		-- Wallpaper daemon
		-- "awww-daemon",
		-- "quickshell -c noctalia-shell",
		"noctalia",
		-- Nextcloud sync (with duplicate guard, delayed start)
		"bash -lc 'pgrep -xu \"$USER\" nextcloud >/dev/null || nextcloud --background &'",
		-- Bluetooth applet (with duplicate guard)
		"bash -lc 'pgrep -xu \"$USER\" blueman-applet >/dev/null || blueman-applet &'",
		-- Network manager applet (with duplicate guard)
		"bash -lc 'pgrep -xu \"$USER\" nm-applet >/dev/null || nm-applet &'",
		-- Waybar (loop restarts on config.jsonc change; CSS reload is native)
		-- os.getenv("HOME") .. "/.config/hypr/scripts/launch-waybar",
		-- Blue light filter
		"systemctl --user start hyprsunset.service",
		-- Hardware cursor fix (delayed)
		"sleep 10s && " .. os.getenv("HOME") .. "/.config/hypr/scripts/fix_hw_cursor.sh",
		-- Polkit agent
		"systemctl --user start hyprpolkitagent",
		-- KWallet initialization
		"/usr/libexec/pam_kwallet_init",
		-- Clipboard manager
		"wl-paste --type text --watch cliphist store",
		"wl-paste --type image --watch cliphist store",
		-- GTK settings
		"gsettings set org.gnome.desktop.interface color-scheme prefer-dark",
		"gsettings set org.gtk.Settings.FileChooser startup-mode cwd",
		"gsettings set org.gtk.gtk4.Settings.FileChooser startup-mode cwd",
	}

	for i = 1, #cmds do
		hl.exec_cmd(cmds[i])
	end
end)
