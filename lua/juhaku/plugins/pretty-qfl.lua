return {
	"yorickpeterse/nvim-pqf",
	config = function()
		local global = require("global")

		require("pqf").setup({
			signs = {
				Error = global.icons.diagnostic.Error,
				Warn = global.icons.diagnostic.Warn,
				Hint = global.icons.diagnostic.Hint,
				Info = global.icons.diagnostic.Info,
			},
		})
	end,
}
