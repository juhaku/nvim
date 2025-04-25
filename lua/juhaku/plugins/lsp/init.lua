local M = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"SmiteshP/nvim-navic",
		"RRethy/vim-illuminate",
		-- "folke/neodev.nvim",
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
}

local global = require("global")

function M.config()
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
		"astro",
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
			-- astro possibly have custom init options that should be added to the config
			if server == "astro" then
				cfg = vim.tbl_deep_extend("force", cfg, { init_options = server_settings.init_options or {} })
			end
		end

		lspconfig[server].setup(cfg)
	end
end

function M.on_attach(client, bufnr)
	-- navic does not need to be attached to astro since it will be comfing via typescript-tools
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
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover({ border = global.border })
	end, attachopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, attachopts)
	vim.keymap.set({ "n", "i" }, "<C-k>", function()
		vim.lsp.buf.signature_help({ border = global.border })
	end, attachopts)
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
				return c.name ~= "ts_ls" or c.name ~= "gopls" or c.name ~= "lua_ls" or c.name ~= "eslint"
			end,
			async = true,
		})
	end, attachopts)
end

return M
