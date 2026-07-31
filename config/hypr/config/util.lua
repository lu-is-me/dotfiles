local M = {}

--- Check whether a process matching `pattern` is currently running.
--- Uses `pgrep -f` so a substring/pattern match is enough (e.g. "quickshell").
function M.is_process_running(pattern)
	local handle = io.popen("pgrep -f " .. pattern .. " 2>/dev/null")
	if not handle then
		return false
	end
	local result = handle:read("*a")
	handle:close()
	return result ~= nil and result:find("%S") ~= nil
end

--- Check whether a process named exactly `name` (comm) is currently running.
function M.is_process_running_exact(name)
	local handle = io.popen("pgrep -x " .. name .. " 2>/dev/null")
	if not handle then
		return false
	end
	local result = handle:read("*a")
	handle:close()
	return result ~= nil and result:find("%S") ~= nil
end

--- True if either quickshell or the standalone noctalia binary is running.
function M.is_shell_running()
	return M.is_process_running_exact("quickshell") or M.is_process_running_exact("noctalia")
end

--- Which noctalia-shell backend is currently running:
--- "noctalia" (standalone daemon, own `noctalia msg` IPC protocol),
--- "quickshell" (noctalia-shell hosted under quickshell, `qs ipc call` protocol),
--- or nil if neither is detected.
function M.shell_backend()
	if M.is_process_running_exact("noctalia") then
		return "noctalia"
	elseif M.is_process_running_exact("quickshell") then
		return "quickshell"
	end
	return nil
end

return M
