local is_ai_enabled = require("global").ai_enabled

return {
	{ "github/copilot.vim", enabled = is_ai_enabled },
	{
		"juhaku/aiwaku.nvim",
		-- dir = "~/dev/repos/aiwaku.nvim",
		dependencies = {
			-- "nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
		enabled = is_ai_enabled,
		opts = {
			cmd = require("global").is_mac() and { "source", "~/.zshrc", "&&", "copilot", "--yolo" }
				or { "~/.local/bin/copilot", "--yolo" },
			-- width = 100,
			keymaps = {
				[{ "n" }] = {
					["<leader>ai"] = {
						command = function()
							require("aiwaku").toggle({ jump = true })
						end,
						description = "Toggle Aiwaku",
					},
				},
			},
			terminal_keymaps = {
				["<Esc>"] = {
					command = "<Esc>",
					description = "Send real Esc to terminal",
				},
				["<A-\\>"] = {
					command = "<Esc>",
					description = "Send real Esc to terminal (alternative)",
				},
				["<A-o>"] = {
					command = "<C-\\><C-n><CMD>tabprev<CR>",
					description = "Prev tab",
				},
				["<A-i>"] = {
					command = "<C-\\><C-n><CMD>tabnext<CR>",
					description = "Next tab",
				},
			},
		},
	},
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
