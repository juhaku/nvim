local global = require("global")

return {
	"stevearc/dressing.nvim",
	opts = {
		input = {
			prefer_width = 60,
			win_options = {
				winblend = global.winblend,
				-- Change default highlight groups (see :help winhl)
				-- winhighlight = "NormalFloat guibg=NONE",
			},
		},
		select = {
			enabled = true,
			winblend = global.winblend,
			backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

			get_config = function(opts)
				if opts.kind == "codeaction" then
					return {
						backend = "builtin",
						builtin = {
							min_height = { 0., 0. },
							relative = "cursor",
						},
					}
				end
			end,
		},
	},
}
