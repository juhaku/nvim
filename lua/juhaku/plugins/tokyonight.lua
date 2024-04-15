return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local global = require("global")
		local ok, tokyonight = pcall(require, "tokyonight")
		if ok == false then
			vim.notify("Tokyonight is not loaded!", vim.log.levels.WARN)
			return
		end

		local opts = {
			style = "night",
			--styles = {
			--    sidebars = "transparent",
			--},
		}

		if global.transparent_background then
			opts = vim.tbl_deep_extend("force", opts, {
				styles = {
					sidebars = "transparent",
				},
			})
		end

		if vim.g.neovide == nil then
			opts = vim.tbl_deep_extend("force", opts, {
				transparent = global.transparent_bacgkround,
			})
		end

		tokyonight.setup(opts)

		vim.cmd([[colorscheme tokyonight]])
	end,
}
