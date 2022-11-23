require("mason").setup({
	ui = {
		border = require("global_options").border,
	},
})
require("mason-lspconfig").setup({
	ensure_installed = {
		"rust_analyzer",
		"gopls",
		-- "goimports",
		-- "gofumpt",
		-- "staticcheck",
		"jdtls",
		"jsonls",
		"dockerls",
		"bashls",
		-- "shellcheck",
		"tsserver",
		-- "prettierd",
		"sumneko_lua",
		-- "stylua",
		-- "markdownlint",
		-- "css-lsp",
		-- "html-lsp",
		-- "node-debug2-adapter",
		-- "vue-language-server",
		-- "yaml-language-server",
	},
})
