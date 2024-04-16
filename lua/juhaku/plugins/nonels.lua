return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		local sources = {
			-- null_ls.builtins.formatting.prettier,
			-- null_ls.builtins.formatting.prettierd, -- TODO
			-- null_ls.builtins.diagnostics.eslint,
			-- null_ls.builtins.code_actions.eslint,
			-- null_ls.builtins.diagnostics.eslint_d,
			-- null_ls.builtins.code_actions.eslint_d,
			-- null_ls.builtins.formatting.eslint_d,
			null_ls.builtins.formatting.stylua,
			-- null_ls.builtins.formatting.beautysh, -- TOOD
			-- null_ls.builtins.code_actions.shellcheck, -- TODO
			null_ls.builtins.formatting.goimports, -- TODO
			null_ls.builtins.formatting.gofumpt, -- TODO
			null_ls.builtins.diagnostics.staticcheck, -- TODO
			-- null_ls.builtins.formatting.markdownlint, -- TODO
			null_ls.builtins.code_actions.gitsigns, -- TODO
			-- require("typescript.extensions.null-ls.code-actions"), -- TODO
		}

		null_ls.setup({ sources = sources })
	end,
}
