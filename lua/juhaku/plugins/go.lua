return {
	{
		"crispgm/nvim-go",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = true,
		opts = {
			lint_prompt_style = "vt",
		},
	},
	{ "leoluz/nvim-dap-go", config = true },
}
