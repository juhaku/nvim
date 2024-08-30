return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local utils = require("juhaku.utils")
		local set = vim.keymap.set
		local opts = { noremap = true, silent = true }
		local trouble = require("trouble")

		set("n", "<C-n>", function()
			local trouble_open = utils.is_window_open("trouble")
			if trouble_open then
				---@diagnostic disable-next-line: missing-parameter, missing-fields
				trouble.next({ focus = true })
			else
				vim.cmd(":cnext<CR>zz")
			end
		end, opts)

		set("n", "<C-p>", function()
			local trouble_open = utils.is_window_open("trouble")
			if trouble_open then
				---@diagnostic disable-next-line: missing-parameter, missing-fields
				trouble.prev({ focus = true })
			else
				vim.cmd(":cprev<CR>zz")
			end
		end, opts)

		trouble.setup()
	end,
}
