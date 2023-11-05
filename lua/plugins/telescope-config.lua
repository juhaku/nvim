local telescope = require("telescope")
local telescope_actions = require("telescope.actions")
local file_browser_actions = telescope.extensions.file_browser.actions

local function telescope_buffer_dir()
	local is_file = vim.fn.system("test -f " .. vim.fn.expand("%") .. " && echo 1")
	if tonumber(is_file) == 1 then
		return vim.fn.expand("%:p:h")
	end

	return vim.fn.getcwd()
end

local function send_to_quickfix(promtbufnr)
	telescope_actions.smart_send_to_qflist(promtbufnr)
	vim.cmd([[botright copen]])
end

telescope.setup({
	defaults = {
		winblend = 20,
		mappings = {
			["n"] = {
				["<C-c>"] = telescope_actions.close,
				["q"] = telescope_actions.close,
				["<C-q>"] = send_to_quickfix,
			},
			["i"] = {
				["<C-c>"] = { "<esc>", type = "command" },
				["<C-q>"] = send_to_quickfix,
			},
		},
	},
	pickers = {
		buffers = {
			mappings = {
				["n"] = {
					["<C-d>"] = telescope_actions.delete_buffer,
				},
				["i"] = {
					["<C-d>"] = telescope_actions.delete_buffer,
				},
			},
		},
	},
	extensions = {
		file_browser = {
			-- hijack_netrw = true,
			initial_mode = "normal",
			previewer = false,
			path = telescope_buffer_dir(),
			cwd_to_path = true,
			respect_gitignore = false,
			hidden = true,
			layout_strategy = "horizontal",
			sorting_strategy = "ascending",
			layout_config = {
				horizontal = {
					mirror = true,
					width = 120,
					height = 40,
					prompt_position = "top",
				},
			},
			mappings = {
				["i"] = {
					["<C-c>"] = { "<esc>", type = "command" },
					["<C-s>"] = telescope_actions.toggle_selection,
					["<A-a>"] = file_browser_actions.create,
					["<C-cr>"] = telescope_actions.file_tab,
					["<C-t>"] = telescope_actions.file_tab,
					-- ["<C-S-w>"] = file_browser_actions.change_cwd,
					["-"] = file_browser_actions.goto_parent_dir,
				},
				["n"] = {
					["m"] = telescope_actions.toggle_selection,
					["<C-cr>"] = telescope_actions.file_tab,
					["t"] = telescope_actions.file_tab,
					["<C-c>"] = telescope_actions.close,
					["q"] = telescope_actions.close,
					["%"] = file_browser_actions.create,
					["cd"] = file_browser_actions.change_cwd,
					-- ["W"] = file_browser_actions.change_cwd,
					["-"] = file_browser_actions.goto_parent_dir,
					-- ["/"] = { "i", type = "command" },
				},
			},
		},
	},
})

telescope.load_extension("file_browser")
telescope.load_extension("fzf")

local keymap_opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>te", function()
	telescope.extensions.file_browser.file_browser({
		path = telescope_buffer_dir(),
	})
end, keymap_opts)

require("plugins.tabs-telescope-picker")
require("plugins.tab-marks-telescope-picker")
