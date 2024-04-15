return {
	{
		"williamboman/mason.nvim",
		config = true,
		opts = {
			ui = {
				border = require("global").border,
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = true,
		opts = {
			ensure_installed = {
				"rust_analyzer",
				"gopls",
				"jdtls",
				"jsonls",
				"dockerls",
				"bashls",
				"tsserver",
				"lua_ls",
                "taplo",
                "yamlls",
                "lemminx",
                "cssls",
                "html",
                "eslint"
			},
		},
	},
}
