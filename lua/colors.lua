local tokyonight = require("tokyonight")
local opts = {
	style = "night",
	styles = {
		sidebars = "transparent",
	},
}

if vim.g.neovide == nil then
	opts = vim.tbl_deep_extend("force", opts, {
		transparent = true,
	})
end

tokyonight.setup(opts)

-- cmds
vim.cmd([[colorscheme tokyonight]])
-- vim.cmd([[
--     highlight FloatBorder guibg=NONE
--     highlight NormalFloat guibg=NONE
-- ]])
