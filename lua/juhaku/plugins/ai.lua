local is_ai_enabled = require("global").ai_enabled

return {
	{ "github/copilot.vim", enabled = is_ai_enabled, otps = {} },
	{ "juhaku/aiwaku.vim", enabled = is_ai_enabled, otps = { cmd = "~/.local/bin/copilot", width = 100 } },
	-- {
	-- 	"olimorris/codecompanion.nvim",
	-- 	version = "^19.0.0",
	-- 	opts = {},
	-- 	enabled = is_ai_enabled,
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"ravitemer/mcphub.nvim",
	-- 	},
	-- },
}
