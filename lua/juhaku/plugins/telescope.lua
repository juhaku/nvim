return {
	{
		"nvim-telescope/telescope.nvim",
		-- version = "0.1.x",
		version = "*",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local telescope_actions = require("telescope.actions")
			local file_browser_actions = telescope.extensions.file_browser.actions
			local global = require("global")

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
					winblend = global.winblend,
					mappings = {
						["n"] = {
							["<C-c>"] = telescope_actions.close,
							["q"] = telescope_actions.close,
							["<C-q>"] = send_to_quickfix,
						},
						["i"] = {
							["<C-c>"] = { "<esc>", type = "command" },
							["<C-q>"] = send_to_quickfix,
							["<A-BS>"] = { "<C-S-w>", type = "command" },
							["<A-h>"] = { "<C-S-w>", type = "command" },
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
					fzf = {},
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
								["<C-m>"] = telescope_actions.toggle_selection,
								["<A-Y>"] = file_browser_actions.move,
								["<C-c>"] = { "<esc>", type = "command" },
								["<A-a>"] = file_browser_actions.create,
								["<A-s>"] = file_browser_actions.open,
								["<CR>"] = file_browser_actions.open_dir,
								["<C-cr>"] = telescope_actions.file_tab,
								["<C-t>"] = telescope_actions.file_tab,
								-- ["<C-S-w>"] = file_browser_actions.change_cwd,
								["-"] = file_browser_actions.goto_parent_dir,
							},
							["n"] = {
								["m"] = telescope_actions.toggle_selection,
								["Y"] = file_browser_actions.move,
								["s"] = file_browser_actions.open,
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

			require("juhaku.tabs-telescope-picker")
			require("juhaku.tab-marks-telescope-picker")
		end,
	},
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
}
