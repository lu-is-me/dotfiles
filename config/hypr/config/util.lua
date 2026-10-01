local M = {}

--- Check whether a process matching `pattern` is currently running.
--- Uses `pgrep -f` so a substring/pattern match is enough (e.g. "nextcloud").
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

return M
