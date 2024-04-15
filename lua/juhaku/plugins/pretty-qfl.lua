return {
	"yorickpeterse/nvim-pqf",
	config = function()
		local global = require("global")

		require("pqf").setup({
			signs = {
				Error = global.diagnostic_signs.Error,
				Warn = global.diagnostic_signs.Warn,
				Hint = global.diagnostic_signs.Hint,
				Info = global.diagnostic_signs.Info,
			},
		})
	end,
}
