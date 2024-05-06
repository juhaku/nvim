return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		local sources = {
			-- null_ls.builtins.formatting.prettier,
			null_ls.builtins.formatting.prettierd,
			-- null_ls.builtins.diagnostics.eslint,
			-- null_ls.builtins.code_actions.eslint,
			-- null_ls.builtins.diagnostics.eslint_d,
			-- null_ls.builtins.code_actions.eslint_d,
			-- null_ls.builtins.formatting.eslint_d,
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.goimports,
			null_ls.builtins.formatting.gofumpt,
			null_ls.builtins.diagnostics.staticcheck,
			null_ls.builtins.diagnostics.revive,
			null_ls.builtins.code_actions.gitsigns,
			null_ls.builtins.formatting.shfmt,
			-- require("typescript.extensions.null-ls.code-actions"),
		}

		null_ls.setup({ sources = sources })
	end,
}
