vim.opt.termguicolors = true
require("bufferline").setup({
	options = {
		mode = "tabs",
		show_close_icon = false,
		-- show_buffer_close_icons = false,
		max_name_length = 25,
		-- max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
		-- truncate_names = true, -- whether or not tab names should be truncated
		-- tab_size = 18,
	},
})
