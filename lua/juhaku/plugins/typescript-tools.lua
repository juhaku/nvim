return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {
		on_attach = function(client, bufnr)
			require("juhaku.plugins.lsp").on_attach(client, bufnr)
			-- disable tsserver formatting
			client.server_capabilities.documentFormattingProvider = false
		end,
		handlers = require("juhaku.plugins.lsp").handlers,
		capabilities = require("juhaku.plugins.cmp").default_capabilities(),
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
			"astro",
		},
		settings = {
			pexpose_as_code_action = "all",
			code_lens = "all",
			tsserver_file_preferences = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
}
