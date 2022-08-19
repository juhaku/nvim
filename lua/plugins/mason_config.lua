require("mason").setup({
	ui = {
		border = require("global_options").border,
	},
})
require("mason-lspconfig").setup({
	ensure_installed = {
		"rust-analyzer",
		"gopls",
		"goimports",
		"gofumpt",
		"staticcheck",
		"json-lsp",
		"dockerfile-language-server",
		"bash-language-server",
		"shellcheck",
		"typescript-language-server",
		"prettierd",
		"lua-language-server",
		"stylua",
		"markdownlint",
		-- "css-lsp",
		-- "html-lsp",
		-- "node-debug2-adapter",
		-- "vue-language-server",
		-- "yaml-language-server",
	},
})
