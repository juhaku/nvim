return {
	"stevearc/oil.nvim",
	opts = {
		default_file_explorer = false,
		prompt_save_on_select_new_entry = false,
		columns = {
			"icon",
			-- "permissions",
			-- "size",
			-- "mtie",
		},
		experimental_watch_for_changes = true,
		keymaps = {
			-- ["g?"] = "actions.show_help",
			-- ["<CR>"] = "actions.select",
			["<C-v>"] = "actions.select_vsplit",
			["<C-x>"] = "actions.select_split",
			["cd"] = {
				callback = function()
					local current_dir = require("oil").get_current_dir()
					if current_dir ~= nil then
						vim.notify("Change working directory to: " .. current_dir, vim.log.levels.INFO)
						vim.uv.chdir(current_dir)
					end
				end,
				desc = "Change working directory to current directory",
				mode = "n",
			},
			-- ["<C-t>"] = "actions.select_tab",
			-- ["<C-p>"] = "actions.preview",
			["<A-\\>"] = "actions.close",
			-- ["<C-l>"] = "actions.refresh",
			-- ["-"] = "actions.parent",
			-- ["_"] = "actions.open_cwd",
			-- ["`"] = "actions.cd",
			-- ["~"] = "actions.tcd",
			-- ["gs"] = "actions.change_sort",
			-- ["gx"] = "actions.open_external",
			-- ["g."] = "actions.toggle_hidden",
			-- ["g\\"] = "actions.toggle_trash",
		},
	},
}
