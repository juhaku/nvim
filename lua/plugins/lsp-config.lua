-- setup signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<F2>", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

local config = {
	virtual_text = true,
	-- show signs
	signs = true,
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	-- float = {
	-- 	focusable = false,
	-- 	style = "minimal",
	-- 	border = "rounded",
	-- 	source = "always",
	-- 	header = "",
	-- 	prefix = "",
	-- },
}

vim.diagnostic.config(config)

-- local handlers = {
-- 	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
-- 	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
-- }

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	if client.name == "sumneko_lua" or client.name == "tsserver" or client.name == "gopls" then
		client.resolved_capabilities.document_formatting = false
	end
	require("illuminate").on_attach(client)

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, bufopts)
	-- vim.keymap.set('n', '<C-p>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, bufopts)

	vim.api.nvim_create_autocmd(
		{ "BufWritePre" },
		{ pattern = { "*" }, command = "lua vim.lsp.buf.formatting_seq_sync()" }
	)
end

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require("lspconfig")["sumneko_lua"].setup({
	on_attach = on_attach,
	-- handlers = handlers,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "use" },
			},
			-- workspace = {
			--     -- Make the server aware of Neovim runtime files
			--     library = vim.api.nvim_get_runtime_file("", true),
			-- },
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

require("lspconfig").gopls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	-- cmd = { "gopls" },
	-- cmd = { "gopls", "serve" },
	-- filetypes = { "go", "gomod" },
	settings = {
		gopls = {
			experimentalWorkspaceModule = true,
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
})

require("lspconfig").bashls.setup({
	on_attach = on_attach,
})

require("typescript").setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
})

-- require("lspconfig").tsserver.setup({
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- 	settings = {
-- 		typescript = {
-- 			inlayHints = {
-- 				includeInlayEnumMemberValueHints = true,
-- 				includeInlayFunctionLikeReturnTypeHints = true,
-- 				includeInlayFunctionParameterTypeHints = true,
-- 				includeInlayParameterNameHints = "all",
-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
-- 				includeInlayPropertyDeclarationTypeHints = true,
-- 				includeInlayVariableTypeHints = true,
-- 			},
-- 		},
-- 		codeActionsOnSave = {
-- 			source = {
-- 				addMissingImports = true,
-- 				fixAll = true,
-- 				removeUnused = true,
-- 				organizeImports = true,
-- 			},
-- 		},
-- 	},
-- })

-- require("lspconfig").eslint.setup({
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- 	settings = {
-- 		codeAction = {
-- 			disableRuleComment = {
-- 				enable = true,
-- 				location = "separateLine",
-- 			},
-- 			showDocumentation = {
-- 				enable = true,
-- 			},
-- 		},
-- 		codeActionOnSave = {
-- 			enable = false,
-- 			mode = "all",
-- 			source = {
-- 				fixAll = true,
-- 				organizeImports = true,
-- 			},
-- 		},
-- 		format = true,
-- 		-- nodePath = "",
-- 		-- onIgnoredFiles = "off",
-- 		-- packageManager = "npm",
-- 		-- quiet = false,
-- 		-- rulesCustomizations = {},
-- 		run = "onType",
-- 		-- useESLintClass = false,
-- 		validate = "on",
-- 		-- workingDirectory = {
-- 		-- 	mode = "location",
-- 		-- },
-- 	},
-- })

require("lspconfig").vuels.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig").html.setup({
	on_attach = on_attach,
})
require("lspconfig").cssls.setup({
	on_attach = on_attach,
})

-- Setup lspconfig.
local json_capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
json_capabilities.textDocument.completion.completionItem.snippetSupport = true
require("lspconfig").jsonls.setup({
	capabilities = json_capabilities,
	on_attach = on_attach,
})

require("lspconfig").yamlls.setup({
	on_attach = on_attach,
	settings = {
		redhat = {
			telemetry = {
				enabled = false,
			},
		},
	},
})

require("lspconfig").dockerls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

local extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codellb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

local rust_analyer_opts = {
	tools = { -- rust-tools options
		autoSetHints = true,

		-- whether to show hover actions inside the hover window
		-- this overrides the default hover handler so something like lspsaga.nvim's hover would be overriden by this
		-- default: true
		hover_with_actions = true,

		-- how to execute terminal commands
		-- options right now: termopen / quickfix
		executor = require("rust-tools/executors").termopen,

		-- callback to execute once rust-analyzer is done initializing the workspace
		-- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
		on_initialized = nil,

		-- These apply to the default RustSetInlayHints command
		inlay_hints = {

			-- Only show inlay hints for the current line
			only_current_line = false,

			-- Event which triggers a refersh of the inlay hints.
			-- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
			-- not that this may cause higher CPU usage.
			-- This option is only respected when only_current_line and
			-- autoSetHints both are true.
			only_current_line_autocmd = "CursorHold",

			-- whether to show parameter hints with the inlay hints or not
			-- default: true
			show_parameter_hints = true,

			-- whether to show variable name before type hints with the inlay hints or not
			-- default: false
			show_variable_name = true,

			-- prefix for parameter hints
			-- default: "<-"
			parameter_hints_prefix = "<- ",

			-- prefix for all the other hints (type, chaining)
			-- default: "=>"
			other_hints_prefix = "=> ",

			-- whether to align to the lenght of the longest line in the file
			max_len_align = false,

			-- padding from the left if max_len_align is true
			max_len_align_padding = 1,

			-- whether to align to the extreme right or not
			right_align = false,

			-- padding from the right if right_align is true
			right_align_padding = 7,

			-- The color of the hints
			highlight = "Comment",
		},

		-- options same as lsp hover / vim.lsp.util.open_floating_preview()
		hover_actions = {
			-- 	-- the border that is used for the hover window
			-- 	-- see vim.api.nvim_open_win()
			-- 	border = {
			-- 		{ "╭", "FloatBorder" },
			-- 		{ "─", "FloatBorder" },
			-- 		{ "╮", "FloatBorder" },
			-- 		{ "│", "FloatBorder" },
			-- 		{ "╯", "FloatBorder" },
			-- 		{ "─", "FloatBorder" },
			-- 		{ "╰", "FloatBorder" },
			-- 		{ "│", "FloatBorder" },
			-- 	},

			-- 	-- whether the hover action window gets automatically focused
			-- 	-- default: false
			-- 	auto_focus = false,
		},
	},

	-- all the opts to send to nvim-lspconfig
	-- these override the defaults set by rust-tools.nvim
	-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
		-- standalone file support
		-- setting it to false may improve startup time
		standalone = false,
		settings = {
			["rust-analyzer"] = {
				imports = {
					granularity = {
						group = "module",
					},
					prefix = "self",
				},
				cargo = {
					buildScripts = {
						enable = true,
					},
				},
				procMacro = {
					enable = true,
					attributes = {
						enable = true,
					},
				},
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
	-- dap = {
	-- 	adapter = {
	-- 		type = "executable",
	-- 		command = "lldb",
	-- 		name = "rt_lldb",
	-- 	},
	-- },
	dap = {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	},
}

-- Normal setup
-- TODO find a way to load project local rust analyzer config to the rust tools setup fn
require("rust-tools").setup(rust_analyer_opts)
require("rust-tools.inlay_hints").setup_autocmd()
-- require("lspconfig")["rust_analyzer"].setup({})

-- TODO find a way to setup rust project features
--  "rust-analyzer.cargo.allFeatures": false,
-- "rust-analyzer.cargo.noDefaultFeatures": true,
-- "rust-analyzer.cargo.features": [
--   "json",
--   // "actix_extras",
--   // "actix-web",
--   "rocket",
--   "rocket_extras",
--   // "axum",
--   // "axum_extras",
--   "debug",
--   "uuid",
--   // "time",
--   "smallvec",
--   "yaml",
-- ]

-- require("plugins.rust-analyzer-config").setup({
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- })
-- require("lspconfig")["rust_analyzer"].setup({})
-- require("lspconfig")["rust_analyzer"].setup({
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- 	-- handlers = handlers,
-- 	-- settings = {
-- 	-- 	["rust-analyzer"] = {
-- 	-- 		imports = {
-- 	-- 			granularity = {
-- 	-- 				group = "module",
-- 	-- 			},
-- 	-- 			prefix = "self",
-- 	-- 		},
-- 	-- 		cargo = {
-- 	-- 			buildScripts = {
-- 	-- 				enable = true,
-- 	-- 			},
-- 	-- 		},
-- 	-- 		procMacro = {
-- 	-- 			enable = true,
-- 	-- 			attributes = {
-- 	-- 				enable = true,
-- 	-- 			},
-- 	-- 		},
-- 	-- 		checkOnSave = {
-- 	-- 			command = "clippy",
-- 	-- 		},
-- 	-- 	},
-- 	-- },
-- })
