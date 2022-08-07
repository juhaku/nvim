local null_ls = require("null-ls")

local sources = {
	-- null_ls.builtins.formatting.prettier,
	null_ls.builtins.formatting.prettierd,
	-- null_ls.builtins.diagnostics.eslint,
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.formatting.beautysh,
	null_ls.builtins.code_actions.shellcheck,
	null_ls.builtins.formatting.goimports,
	null_ls.builtins.formatting.gofumpt,
	null_ls.builtins.diagnostics.staticcheck,
	null_ls.builtins.formatting.markdownlint,
	-- null_ls.builtins.code_actions.gitsigns,
}

null_ls.setup({ sources = sources })
