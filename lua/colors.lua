local tokyonight = require("tokyonight")
local opts = {}

if vim.g.neovide == nil then
	opts = vim.tbl_deep_extend("force", opts, {
		style = "night",
		transparent = true,
		styles = {
			sidebars = "transparent",
		},
	})
end

tokyonight.setup(opts)

-- cmds
vim.cmd([[colorscheme tokyonight]])
-- vim.cmd([[
--     highlight FloatBorder guibg=NONE
--     highlight NormalFloat guibg=NONE
-- ]])
