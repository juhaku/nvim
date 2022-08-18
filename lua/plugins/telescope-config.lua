local telescope = require("telescope")
local telescope_actions = require("telescope.actions")
local file_browser_actions = telescope.extensions.file_browser.actions

telescope.setup({
	defaults = {
		winblend = 20,
		mappings = {
			["n"] = {
				["<C-c>"] = telescope_actions.close,
				["q"] = telescope_actions.close,
			},
		},
	},
	extensions = {
		file_browser = {
			theme = "dropdown",
			hijack_netrw = true,
			initial_mode = "normal",
			previewer = false,
			layout_config = {
				center = {
					height = 40,
					width = 120,
				},
			},
			mappings = {
				["i"] = {
					["<C-c>"] = { "<esc>", type = "command" },
					["<C-x>"] = telescope_actions.toggle_selection,
					["<A-a>"] = file_browser_actions.create,
				},
				["n"] = {
					["x"] = telescope_actions.toggle_selection,
					["<C-c>"] = telescope_actions.close,
					["q"] = telescope_actions.close,
					["a"] = file_browser_actions.create,
					["/"] = { "i", type = "command" },
				},
			},
		},
	},
})
telescope.load_extension("file_browser")
