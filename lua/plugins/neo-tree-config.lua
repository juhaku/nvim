local neotree_filesystem = require("neo-tree.sources.filesystem")

require("neo-tree").setup({
	default_component_configs = {
		symlink_target = {
			enabled = true,
		},
	},
	close_if_last_window = false,
	window = {
		width = 50,
		mappings = {
			["Z"] = "expand_all_nodes",
			["<tab>"] = function(state)
				state.commands["open"](state)
				vim.cmd("Neotree reveal")
			end,
			["h"] = function(state)
				local node = state.tree:get_node()
				if node.type == "directory" and node:is_expanded() then
					neotree_filesystem.toggle_directory(state, node)
				end
			end,
			["l"] = function(state)
				local node = state.tree:get_node()
				if node.type == "directory" then
					if not node:is_expanded() then
						neotree_filesystem.toggle_directory(state, node)
					end
				end
			end,
			["-"] = {
				"navigate_up",
			},
			["w"] = {
				"set_root",
			},
			["cd"] = {
				"set_root",
			},
			["%"] = {
				"add",
			},
			["X"] = {
				"system_open",
			},
		},
	},
	filesystem = {
		filtered_items = {
			never_show = {
				"node_modules",
			},
		},
		follow_current_file = {
			enabled = true,
			leave_dirs_open = true,
		},
		hijack_netrw_behavior = "disabled",
	},
	commands = {
		system_open = function(state)
			local node = state.tree:get_node()
			local path = node:get_id()
			vim.fn.jobstart({ "xdg-open", path }, { detach = true })
		end,
	},
})
