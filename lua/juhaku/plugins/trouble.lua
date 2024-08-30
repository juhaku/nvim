return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local set = vim.keymap.set
		local opts = { noremap = true, silent = true }
		local trouble = require("trouble")
		set("n", "<C-n>", function()
			if trouble.is_open() then
				---@diagnostic disable-next-line: missing-parameter, missing-fields
				trouble.next({ focus = true })
			else
				vim.cmd(":cnext<CR>zz")
			end
		end, opts)

		set("n", "<C-p>", function()
			if trouble.is_open() then
				---@diagnostic disable-next-line: missing-parameter, missing-fields
				trouble.prev({ focus = true })
			else
				vim.cmd(":cprev<CR>zz")
			end
		end, opts)

		trouble.setup()
	end,
}
