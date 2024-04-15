return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			mode = "tabs",
			show_close_icon = false,
			-- show_buffer_close_icons = false,
			max_name_length = 50,
			max_prefix_length = 25,
			-- buffer_close_icon = "",
			-- truncate_names = true, -- whether or not tab names should be truncated
			-- tab_size = 18,
		},
	},
}
