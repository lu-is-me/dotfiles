-- DMS user keybind overrides (edit via Control Center or dms; do not remove this header)

hl.unbind("ALT + P")
hl.bind("ALT + P", hl.dsp.exec_cmd("dms ipc call spotlight-bar toggle"), { description = "Spotlight Bar: Toggle" })
hl.unbind("SUPER + Z")
hl.bind("SUPER + Z", hl.dsp.exec_cmd("dms ipc call spotlight open"), { description = "Default Launcher: Open" })
hl.unbind("SUPER + Period")
hl.bind("SUPER + Period", hl.dsp.exec_cmd("dms ipc call dot open launcher"), { description = "DankDot: Open Launcher" })
