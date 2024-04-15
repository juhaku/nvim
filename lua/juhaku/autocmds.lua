local global = require("global")

if global.auto_close_missing_buffers == true then
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

-- rotate lsp logs
local lsp_log = os.getenv("HOME") .. "/.local/state/nvim/lsp.log"

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	pattern = "*",
	callback = function()
		local size_in_bytes = vim.fn.system("stat --format=%s " .. lsp_log)
		local size = tonumber(size_in_bytes)
		if size ~= nil and size > 10 * 1024 * 1024 then
			vim.notify("lsp.log is bigger than 10Mb, rotating file", vim.log.levels.INFO)
			local date = vim.fn.system("date --iso-8601=date")
			vim.fn.system("mv " .. lsp_log .. " " .. lsp_log .. ".old." .. date)
			vim.fn.system("touch" .. lsp_log)
			vim.fn.system("fd lsp.log.old --older 3months" .. os.getenv("HOME") .. "/.local/state/nvim --exec rm -f {}")
		end
	end,
})

-- auto save file
if global.autosave == true then
	vim.api.nvim_create_autocmd("User", {
		pattern = "PlenaryLoaded",
		callback = function()
			local plenaryok, async = pcall(require, "plenary.async")
			if plenaryok == false then
				vim.notify("Pleanry is not loaded, cannot set auto save", vim.log.levels.WARN)
				return
			end
			local _timer = nil
			local save_file = function(id)
				if id ~= nil then
					---@diagnostic disable-next-line: missing-parameter
					async.run(function()
						vim.fn.timer_stop(id)
					end)
				end
				vim.cmd("write")
			end

			vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
				pattern = { "*" },
				callback = function(change_opts)
					local is_file = nil
					if change_opts.file ~= "" then
						is_file = tonumber(vim.fn.system("test -f " .. change_opts.file .. "&& echo 1"))
					end
					if is_file ~= nil and is_file == 1 then
						if _timer ~= nil then
							---@diagnostic disable-next-line: missing-parameter
							async.run(function()
								vim.fn.timer_stop(_timer)
							end)
							_timer = nil
						end

						_timer = vim.fn.timer_start(300, save_file)
					end
				end,
			})
		end,
	})
end

-- try refresh codelens
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
	pattern = { "*.java", "*.ts", "*.go", "*.rs" },
	callback = function()
		local _, _ = pcall(vim.lsp.codelens.refresh)
	end,
})
