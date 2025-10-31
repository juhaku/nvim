return {
	{
		"mason-org/mason.nvim",
		config = true,
		opts = {
			ui = {
				border = require("global").border,
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = true,
		opts = {
			ensure_installed = require("juhaku.plugins.lsp").servers,
			automatic_enable = false, -- enabling is done in LSP init.lua
		},
	},
}
