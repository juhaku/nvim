if require("global_options").auto_close_missing_buffers == true then
	vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
		pattern = "*",
		callback = function(o)
			local exists = vim.fn.system("test -f " .. o.match .. " && echo 1")
			if tonumber(exists) ~= 1 then
				vim.notify("file: " .. o.match .. " does not exists", vim.log.levels.INFO)
				local wins = vim.fn.win_findbuf(o.buf)
				for _, win in ipairs(wins) do
					vim.api.nvim_win_close(win, true)
				end
			end
		end,
	})
end

local lsp_log = os.getenv("HOME") .. "/.local/state/nvim/lsp.log"

vim.api.nvim_create_autocmd({"VimEnter"}, {
    pattern = "*",
    callback = function ()
        local size_in_bytes = vim.fn.system("stat --format=%s " .. lsp_log)
        if tonumber(size_in_bytes) > 10 * 1024 * 1024 then
            vim.notify("lsp.log is bigger than 10Mb, rotating file", vim.log.levels.INFO)
            local date = vim.fn.system("date --iso-8601=date")
            vim.fn.system("mv " .. lsp_log .. " " .. lsp_log .. ".old." .. date)
            vim.fn.system("touch" .. lsp_log)
            vim.fn.system("fd lsp.log.old --older 3months" .. os.getenv("HOME") .. "/.local/state/nvim --exec rm -f {}")
        end
    end
})
