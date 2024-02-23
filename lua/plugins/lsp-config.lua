local global_options = require("global_options")

for type, icon in pairs(global_options.diagnostic_signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local border = require("global_options").border

require("lsp-inlayhints").setup({
	inlay_hints = {
		parameter_hints = {
			show = true,
			prefix = "<- ",
			separator = ", ",
			remove_colon_start = false,
			remove_colon_end = true,
		},
		type_hints = {
			-- type and other hints
			show = true,
			prefix = "=> ",
			separator = ", ",
			remove_colon_start = false,
			remove_colon_end = false,
		},
	},
})
vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
	group = "LspAttach_inlayhints",
	callback = function(args)
		if not (args.data and args.data.client_id) then
			return
		end

		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		-- only gopls, java, typescript and rust is handled here
		if
			client.name == "tsserver"
			or client.name == "jdtls"
			or client.name == "gopls"
			or client.name == "rust-analyzer"
		then
			require("lsp-inlayhints").on_attach(client, bufnr)
		end
	end,
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<A-d>", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, opts)

local config = {
	virtual_text = true,
	-- show signs
	signs = true,
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = true,
		style = "minimal",
		border = border,
		-- source = "always",
		-- header = "",
		-- prefix = "",
	},
}

vim.diagnostic.config(config)

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

local async = require("plenary.async")
local _timer = nil
local save_file = function(id)
	if id ~= nil then
		---@diagnostic disable-next-line: missing-parameter
		async.run(function()
			vim.fn.timer_stop(id)
		end)
	end
	vim.cmd("write")
end

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	pattern = { "*" },
	callback = function(change_opts)
		local is_file = 0
		if change_opts.file ~= "" then
			is_file = vim.fn.system("test -f " .. change_opts.file .. "&& echo 1")
		end
		if tonumber(is_file) == 1 then
			if _timer ~= nil then
				---@diagnostic disable-next-line: missing-parameter
				async.run(function()
					vim.fn.timer_stop(_timer)
				end)
				_timer = nil
			end

			_timer = vim.fn.timer_start(300, save_file)
		end
	end,
})

local codelens_try_refresh = function()
	local _, _ = pcall(vim.lsp.codelens.refresh)
end

-- vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*" }, command = "lua vim.lsp.buf.format()" })
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
-- 	pattern = { "*" },
-- 	callback = function()
-- 		vim.lsp.buf.format({
-- 			timeout_ms = 1000,
-- 			filter = function(client)
-- 				return client.name ~= "tsserver"
-- 					or client.name ~= "gopls"
-- 					or client.name ~= "lua_ls"
-- 					or client.name ~= "eslint"
-- 			end,
-- 		})
-- 	end,
-- })

local navic = require("nvim-navic")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
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
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "td", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, bufopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<A-CR>", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("v", "<A-CR>", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)

	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.format({
			filter = function(c)
				return c.name ~= "tsserver" or c.name ~= "gopls" or c.name ~= "lua_ls" or c.name ~= "eslint"
			end,
			async = true,
		})
	end, bufopts)
end

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig")["lua_ls"].setup({
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		on_attach(client, bufnr)
	end,
	handlers = handlers,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "use" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.go" },
	callback = function()
		codelens_try_refresh()
	end,
})
require("go").setup({
	lint_prompt_style = "vt",
})
require("lspconfig").gopls.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		codelens_try_refresh()
		on_attach(client, bufnr)
	end,
	handlers = handlers,
	-- cmd = { "gopls" },
	-- cmd = { "gopls", "serve" },
	-- filetypes = { "go", "gomod" },
	settings = {
		gopls = {
			-- already removed
			-- experimentalWorkspaceModule = true,
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			-- use defaults
			-- codelenses = {
			--     gc_details = true,
			--     generate = true,
			--     regenerate_cgo = true,
			--     tidy = true,
			--     upgrade_dependency = true,
			--     vendor = true,
			-- },
			--
			hints = {
				parameterNames = true,
				constantValues = true,
				functionTypeParameters = true,
				assignVariableTypes = true,
				compositeLiteralFields = true,
				rangeVariableTypes = true,
			},
		},
	},
})

require("lspconfig").bashls.setup({
	on_attach = on_attach,
	handlers = handlers,
})

local typescript = require("typescript")

-- local function ts_on_save()
-- 	local lsp_config_util = require("lspconfig.util")
-- 	local ts_save_group = vim.api.nvim_create_augroup("TsOnSave", {})

-- 	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
-- 		pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
-- 		group = ts_save_group,
-- 		callback = function(options)
-- 			local eslint_lsp_client = lsp_config_util.get_active_client_by_name(options.buf, "eslint")
-- 			if eslint_lsp_client ~= nil then
-- 				vim.cmd("EslintFixAll")
-- 				-- vim.cmd("redraw")
-- 				-- vim.cmd("write")
-- 			end

-- 			local tsserver_lsp_client = lsp_config_util.get_active_client_by_name(options.buf, "tsserver")
-- 			if tsserver_lsp_client ~= nil then
-- 				local typescript_acions = typescript.actions
-- 				-- typescript_acions.addMissingImports({ sync = true })
-- 				-- vim.cmd("redraw")
-- 				typescript_acions.fixAll({ sync = true })
-- 				-- vim.cmd("redraw")
-- 				-- vim.cmd("write")
-- 				-- typescript_acions.organizeImports({ sync = true })
-- 				-- vim.cmd("redraw")
-- 			end
-- 		end,
-- 	})
-- end

typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			-- ts_on_save()

			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "<leader><leader>o", function()
				typescript.actions.organizeImports({ sync = true })
				-- typescript.actions.fixAll({ sync = true })
			end, bufopts)
			vim.keymap.set("n", "<leader><leader>i", function()
				typescript.actions.addMissingImports({ sync = true })
				-- typescript.actions.fixAll({ sync = true })
			end, bufopts)

			-- add command to perform code actions on write
			-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			-- 	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
			-- 	command = ":TypescriptAddMissingImports!",
			-- })
			-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			-- 	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
			-- 	command = ":TypescriptOrganizeImports!",
			-- })
			-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			-- 	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
			-- 	command = ":TypescriptFixAll!",
			-- })

			on_attach(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
		end,
		handlers = handlers,
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
			javascript = {
				inlayHints = {
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
	},
})

require("lspconfig").eslint.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		-- ts_on_save()
		-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
		-- 	pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
		-- 	command = ":EslintFixAll",
		-- })
		client.server_capabilities.documentFormattingProvider = false
		on_attach(client, bufnr)
	end,
})

require("lspconfig").vuels.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers,
})

local html_capablities = require("cmp_nvim_lsp").default_capabilities()
html_capablities.textDocument.completion.completionItem.snippetSupport = true
require("lspconfig").html.setup({
	on_attach = on_attach,
	handlers = handlers,
	capabilities = html_capablities,
})

require("lspconfig").cssls.setup({
	on_attach = on_attach,
	handlers = handlers,
	capabilities = html_capablities,
})

require("lspconfig").lemminx.setup({
	on_attach = on_attach,
	handlers = handlers,
	capabilities = capabilities,
	settings = {
		redhat = {
			telemetry = {
				enabled = false,
			},
		},
	},
})

-- Setup lspconfig.
local json_capabilities = require("cmp_nvim_lsp").default_capabilities()
json_capabilities.textDocument.completion.completionItem.snippetSupport = true
require("lspconfig").jsonls.setup({
	capabilities = json_capabilities,
	on_attach = on_attach,
	handlers = handlers,
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

-- toml lsp server
require("lspconfig").taplo.setup({
	on_attach = on_attach,
	handlers = handlers,
})

-- local util = require("lspconfig.util")
require("lspconfig").yamlls.setup({
	on_attach = function(client, bufnr)
		-- local chart_path = util.root_pattern("Chart.yaml", "Chart.yml")
		-- if chart_path ~= nil then
		-- 	print("disabling diagnostics for helm chart")
		-- 	vim.diagnostic.disable(bufnr)
		-- end

		return on_attach(client, bufnr)
	end,
	handlers = handlers,
	settings = {
		yaml = {
			schemaStore = {
				enable = true,
			},
		},
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
	handlers = handlers,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.rs" },
	callback = function()
		codelens_try_refresh()
	end,
})

vim.g.rustaceanvim = {
	tools = {
	},
	server = {
		on_attach = function(client, bufnr)
			codelens_try_refresh()
			on_attach(client, bufnr)
		end,
		settings = function(project_root)
			local rust_analyzer_settings = project_root .. "/.nvim/rust-analyzer.json"
			local default_config = require("rustaceanvim.config.internal")
			local default_settings = default_config.server.default_settings

			local has_project_settings = tonumber(vim.fn.system("test -f " .. rust_analyzer_settings .. " && echo 1"))
			if has_project_settings == 1 then
				vim.notify("found ./nvim/rust-analyzer.json project settings", vim.log.levels.DEBUG)
				local content = vim.fn.system("cat " .. rust_analyzer_settings)
				local success, json = pcall(vim.fn.json_decode, content)
				if success then
					-- merge default config with the project settings
					local merged_config = {
						["rust-analyzer"] = vim.tbl_deep_extend("force", default_settings["rust-analyzer"], json),
					}
					-- vim.notify(
					-- 	"project settings is correct json using default settings merged with project settings",
					-- 	vim.log.levels.TRACE
					-- )
					-- vim.notify(vim.inspect(merged_config), vim.log.levels.TRACE)
					return merged_config
				else
					vim.notify(
						"failed to decode project settings as json, using default settings",
						vim.log.levels.WARN
					)
					vim.notify(vim.inspect(default_config), vim.log.levels.TRACE)
					-- use defautl settings
					return default_settings
				end
			end
			-- vim.notify("no project settings using default settings", vim.log.levels.DEBUG)
			-- vim.notify(vim.inspect(default_config), vim.log.levels.TRACE)
			return default_settings
		end,
		default_settings = {
			-- rust-analyzer language server configuration
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
					features = {},
					noDefaultFeatures = false,
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
}

require("flutter-tools").setup({
	debugger = {
		enabled = true,
		register_configurations = function(_)
			require("dap").configurations.dart = {
				{
					name = "Flutter",
					request = "launch",
					type = "dart",
					flutterMode = "debug",
				},
			}
			require("dap.ext.vscode").load_launchjs()
		end,
	},
	lsp = {
		handlers = handlers,
		on_attach = on_attach,
		capabilities = capabilities,
	},
})

local M = {}

M.on_attach = on_attach
M.capabilities = capabilities
M.handlers = handlers
M.codelens_try_refresh = codelens_try_refresh

return M
