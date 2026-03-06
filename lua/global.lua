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

---@class Icons Icons
---@field diagnostic DiagnosticSigns table of diagnostic icons
---@field kind table table of completion kind icons
---@field git_signs GitSigns table of gitsigns icons

---@class GitSigns git signs.
---@field add string add icon
---@field change string change icon
---@field delete string delete icon
---@field topdelete string top delete icon
---@field changedelete string change delete icon

return {
	---@type string global border style for neovim floating windows
	border = "rounded",

	---@type Icons table of icons
	icons = {
		---@type DiagnosticSigns vim diagnostic signs used globally
		diagnostic = {
			Error = "",
			Warn = "",
			Hint = "󰌶",
			Info = "󰋽",
		},

		---@type table kind icons for completion
		kind = {
			Text = "",
			Method = "󰆧",
			Function = "󰊕",
			Constructor = "",
			Field = "󰇽",
			Variable = "󰂡",
			Class = "󰠱",
			Interface = "",
			Module = "",
			Property = "󰜢",
			Unit = "",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "󰏘",
			File = "󰈙",
			Reference = "",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰏿",
			Struct = "",
			Event = "",
			Operator = "󰆕",
			TypeParameter = "󰅲",
		},

		---@type GitSigns git signs icons
		git_signs = {
			add = "▎",
			change = "▎",
			delete = "",
			topdelete = "",
			changedelete = "▎",
		},
	},

	---@type boolean automatically close buffers with non existing files
	auto_close_missing_buffers = true,

	---@type boolean use transparent background for colortheme
	transparent_bacgkround = false,

	---@type number define winblend amount globally
	winblend = 20,

	---@type boolean whether autosave files or not
	autosave = true,

	---Check whether system is MacOS or not
	---@return boolean true when system is mac; false otherwise
	is_mac = function()
		local sysname = vim.uv.os_uname().sysname
		return sysname == "Darwin"
	end,

	---@type boolean force eol for each opened file
	force_eol = true,

    ---@type boolean are AI tools such as copilot and code companion enabled
    ai_enabled = true
}
