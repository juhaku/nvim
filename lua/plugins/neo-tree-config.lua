require("neo-tree").setup({
	close_if_last_window = false,
	window = {
		width = 50,
		mappings = {
			-- ["Z"] = "expand_all_nodes",
			["<tab>"] = function(state)
				state.commands["open"](state)
				vim.cmd("Neotree reveal")
			end,
			["h"] = function(state)
				local node = state.tree:get_node()
				if node.type == "directory" and node:is_expanded() then
					require("neo-tree.sources.filesystem").toggle_directory(state, node)
				end
			end,
			["l"] = function(state)
				local node = state.tree:get_node()
				if node.type == "directory" then
					if not node:is_expanded() then
						require("neo-tree.sources.filesystem").toggle_directory(state, node)
					end
				end
			end,
		},
	},
	filesystem = {
		filtered_items = {
			never_show = {
				"node_modules",
			},
		},
		hijack_netrw_behavior = "disabled",
	},
})
