local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"SmiteshP/nvim-navic",
		"RRethy/vim-illuminate",
		"folke/neodev.nvim",
	},
}

local global = require("global")
M.handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = global.border }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = global.border }),
}

function M.config()
	local opts = { noremap = true, silent = true }
	vim.keymap.set("n", "<A-d>", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)
	vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, opts)

	for type, icon in pairs(global.diagnostic_signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	local config = {
		virtual_text = true,
		signs = true,
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = global.border,
		},
	}
	vim.diagnostic.config(config)

	local servers = {
		"lua_ls",
		"gopls",
		"bashls",
		"dockerls",
		"jsonls",
		"taplo",
		"yamlls",
		"lemminx",
		"cssls",
		"html",
		"eslint",
	}

	local capabilities = require("juhaku.plugins.cmp").default_capabilities()
	local lspconfig = require("lspconfig")
	for _, server in ipairs(servers) do
		-- if server == "html" or server == "cssls" or server == "jsonls" then
		-- 	capabilities.textdocument.completion.completionItem.snippetSupport = true
		-- end

		local cfg = {
			on_attach = M.on_attach,
			capabilities = capabilities,
			handlers = M.handlers,
		}

		local ok, server_settings = pcall(require, "juhaku.plugins.lsp.servers." .. server)
		if ok then
			if server_settings.on_attach ~= nil then
				cfg.on_attach = function(client, bufnr)
					M.on_attach(client, bufnr)
					server_settings.on_attach(client, bufnr)
				end
			end
			cfg = vim.tbl_deep_extend("force", cfg, {
				settings = server_settings.settings,
			})
		end

		if server == "lua_ls" then
			require("neodev").setup({})
		end

		lspconfig[server].setup(cfg)
	end
end

function M.on_attach(client, bufnr)
	if client.server_capabilities.documentSymbolProvider then
		require("nvim-navic").attach(client, bufnr)
	end

	require("illuminate").on_attach(client)

	if client.supports_method("textDocument/inlayHint") then
		vim.lsp.inlay_hint.enable(true, { bufnr })
	end
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

	-- Buffer local mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local attachopts = { buffer = bufnr, noremap = true, silent = true }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, attachopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, attachopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, attachopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, attachopts)
	vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, attachopts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, attachopts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, attachopts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, attachopts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, attachopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, attachopts)
	vim.keymap.set({ "n", "v" }, "<A-CR>", vim.lsp.buf.code_action, attachopts)
	vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, attachopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, attachopts)
	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.format({
			filter = function(c)
				return c.name ~= "tsserver" or c.name ~= "gopls" or c.name ~= "lua_ls" or c.name ~= "eslint"
			end,
			async = true,
		})
	end, attachopts)
	-- vim.keymap.set('n', '<leader>f', function()
	--     vim.lsp.buf.format { async = true }
	-- end, opts)
end

return M
