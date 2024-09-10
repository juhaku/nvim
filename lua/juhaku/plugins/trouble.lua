return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local set = vim.keymap.set
		local opts = { noremap = true, silent = true }
		local trouble = require("trouble")
		set("n", "<A-n>", function()
			if trouble.is_open() then
				---@diagnostic disable-next-line: missing-parameter, missing-fields
				trouble.next({ follow = true })
				---@diagnostic disable-next-line: missing-parameter, missing-fields
                trouble.jump()
			end
		end, opts)

		set("n", "<A-p>", function()
			if trouble.is_open() then
				---@diagnostic disable-next-line: missing-parameter, missing-fields
				trouble.prev({ follow = true })
                ---@diagnostic disable-next-line: missing-parameter, missing-fields
                trouble.jump()
			end
		end, opts)

		trouble.setup()
	end,
}
