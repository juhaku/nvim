if require("global_options").auto_close_missing_buffers == true then
	vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
		pattern = "*",
		callback = function(o)
			local exists = vim.fn.system("test -f " .. o.match .. " && echo true")
			if exists ~= "true" then
				local wins = vim.fn.win_findbuf(o.buf)
				for _, win in ipairs(wins) do
					vim.api.nvim_win_close(win, true)
				end
			end
		end,
	})
end
