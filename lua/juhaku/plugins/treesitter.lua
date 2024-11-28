return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"rust",
					"go",
					"gomod",
					"typescript",
					"javascript",
					"jsdoc",
					"bash",
					"java",
					"html",
					"yaml",
					"json",
					"toml",
					"kotlin",
					"tsx",
					"dart",
					"dockerfile",
					"graphql",
					--"vue",
					"scss",
					"jsonc",
					"sql",
					"markdown",
					"vim",
					"vimdoc",
					-- "proto",
					"astro",
				},
				sync_install = false,
				auto_install = false,
				ignore_install = {},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "vn",
						node_incremental = "vn",
						scope_incremental = "grc",
						node_decremental = "vN",
					},
				},
				indent = {
					enable = true,
				},
				refactor = {
					highlight_definitions = {
						enable = true,
						-- 	-- Set to false if you have an `updatetime` of ~100.
						-- 	clear_on_cursor_move = true,
					},
					-- highlight_current_scope = { enable = true },
					smart_rename = {
						enable = true,
						keymaps = {
							smart_rename = "grr",
						},
					},
					-- navigation = {
					--   enable = true,
					--   keymaps = {
					--     goto_definition = "gnd",
					--     list_definitions = "gnD",
					--     list_definitions_toc = "gO",
					--     goto_next_usage = "<a-*>",
					--     goto_previous_usage = "<a-#>",
					--   },
					-- }
				},
				textobjects = { enable = true },
			})
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-refactor" },
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup()
		end,
	},
}
