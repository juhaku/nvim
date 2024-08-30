local M = {}

---Check whether window with `name` is open
---@param pattern string pattern of the window name
function M.is_window_open_by_name_pattern(pattern)
	local wins = vim.api.nvim_list_wins()

	local open = false
	for _, win in ipairs(wins) do
		local buf = vim.api.nvim_win_get_buf(win)
		local name = vim.api.nvim_buf_get_name(buf)
		if name:match(pattern) then
			open = true
			break
		end
	end

	return open
end

return M
