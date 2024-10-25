return {
	{
		"crispgm/nvim-go",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = true,
		opts = {
			lint_prompt_style = "vt",
			auto_format = false,
			auto_lint = false,
		},
	},
	{ "leoluz/nvim-dap-go", config = true },
}
