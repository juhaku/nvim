local api = require("nvim-tree.api")
local global_options = require("global_options")

local function close_node()
	api.node.navigate.parent_close()
end

local function edit_or_open()
	local node = api.tree.get_node_under_cursor()

	if node.nodes ~= nil then
		api.node.open.edit()
	else
		api.node.open.edit()
		api.tree.close()
	end
end

local function on_attach(bufnr)
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end
	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	vim.keymap.set("n", "cd", api.tree.change_root_to_node, opts("CD"))
	-- vim.keymap.set("n", "w", api.tree.change_root_to_node, opts("CD"))
	vim.keymap.set("n", "%", api.fs.create, opts("Create"))
	vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
	vim.keymap.set("n", "h", close_node, opts("Close"))
end

require("nvim-tree").setup({
	on_attach = on_attach,
	reload_on_bufenter = true,
	select_prompts = true,
	hijack_netrw = false,
	view = {
		width = 50,
	},
	renderer = {
		root_folder_label = ":~:s?$?/?",
		special_files = {},
		highlight_git = true,
		highlight_diagnostics = true,
		highlight_modified = "all",
		indent_markers = {
			enable = true,
		},
		icons = {
			show = {
				folder_arrow = true,
			},
		},
	},
	modified = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = true,
	},
	hijack_directories = {
		enable = false,
		auto_open = true,
	},
	update_focused_file = {
		enable = true,
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = true,
		debounce_delay = 50,
		icons = {
			hint = global_options.diagnostic_signs.Hint:gsub("%s", ""),
			info = global_options.diagnostic_signs.Info:gsub("%s", ""),
			warning = global_options.diagnostic_signs.Warn:gsub("%s", ""),
			error = global_options.diagnostic_signs.Error:gsub("%s", ""),
		},
	},
	filters = {
		git_ignored = true,
		dotfiles = true,
		git_clean = false,
		no_buffer = false,
		custom = {},
		exclude = {
			"node_modules",
		},
	},
	actions = {
		expand_all = {
			exclude = {
				"node_modules",
				"target",
				"build",
				".git",
			},
		},
	},
	tab = {
		sync = {
			open = true,
			close = true,
			ignore = {},
		},
	},
})
