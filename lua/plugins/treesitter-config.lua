require("nvim-treesitter.configs").setup({
	-- A list of parser names, or 'nvim-treesitter.configs'"all"
	ensure_installed = {
		"lua",
		"rust",
		"go",
		"gomod",
		"typescript",
		"javascript",
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
		"vue",
		"scss",
		"jsonc",
		"sql",
		"markdown",
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- List of parsers to ignore installing (for "all")
	-- ignore_install = { "javascript" },

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		-- disable = { "c", "rust" },

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
	refactor = {
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
})