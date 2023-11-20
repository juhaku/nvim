-- border = {
-- 	{ "╭", "FloatBorder" },
-- 	{ "─", "FloatBorder" },
-- 	{ "╮", "FloatBorder" },
-- 	{ "│", "FloatBorder" },
-- 	{ "╯", "FloatBorder" },
-- 	{ "─", "FloatBorder" },
-- 	{ "╰", "FloatBorder" },
-- 	{ "│", "FloatBorder" },
-- },

---@class DiagnosticSigns Vim diagnostic signs.
---@field Error string error diagnostic sign
---@field Warn string warn diagnostic sign
---@field Hint string hint diagnostic sign
---@field Info string info diagnostic sign

return {
	---@type string global border style for neovim floating windows
	border = "rounded",

	---@type DiagnosticSigns vim diagnostic signs used globally
	diagnostic_signs = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	},

	---@type boolean automatically close buffers with non existing files
	auto_close_missing_buffers = true,
}
