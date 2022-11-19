-- setup signs
vim.opt.termguicolors = true
require("bufferline").setup({
    options = {
        mode = "tabs",
        show_close_icon = false,
        -- show_buffer_close_icons = false,
        max_name_length = 50,
        -- max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        -- truncate_names = true, -- whether or not tab names should be truncated
        -- tab_size = 18,
    },
})
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local border = {
    { "╭", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╮", "FloatBorder" },
    { "│", "FloatBorder" },
    { "╯", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╰", "FloatBorder" },
    { "│", "FloatBorder" },
}

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-S-d>", vim.diagnostic.open_float, opts)
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
                async.run(function()
                    vim.fn.timer_stop(_timer)
                end)
                _timer = nil
            end

            _timer = vim.fn.timer_start(300, save_file)
        end
    end,
})

-- vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*" }, command = "lua vim.lsp.buf.format()" })
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
-- 	pattern = { "*" },
-- 	callback = function()
-- 		vim.lsp.buf.format({
-- 			timeout_ms = 1000,
-- 			filter = function(client)
-- 				return client.name ~= "tsserver"
-- 					or client.name ~= "gopls"
-- 					or client.name ~= "sumneko_lua"
-- 					or client.name ~= "eslint"
-- 			end,
-- 		})
-- 	end,
-- })

-- local navic = require("nvim-navic")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- if client.server_capabilities.documentSymbolProvider then
    -- 	local filename = vim.fn.expand("%")
    -- 	-- local location = navic.get_location()
    -- 	vim.o.winbar = filename .. " > " .. "%{%v:lua.require'nvim-navic'.get_location()%}"
    -- 	navic.attach(client, bufnr)
    -- end
    -- if
    -- 	client.name == "sumneko_lua"
    -- 	or client.name == "gopls"
    -- 	or client.name == "tsserver"
    -- 	or client.name == "eslint"
    -- then
    -- 	client.server_capabilities.document_formatting = false
    -- end
    require("illuminate").on_attach(client)

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    -- vim.keymap.set("n", "gd", ":Trouble lsp_definitions<CR>", bufopts)
    -- vim.keymap.set(
    -- 	"n",
    -- 	"gd",
    -- 	":lua require('telescope.builtin').lsp_definitions({layout_config = {height = 50}}) <cr>",
    -- 	bufopts
    -- )
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    -- vim.keymap.set("n", "gi", ":Trouble lsp_implementations<CR>", bufopts)
    -- vim.keymap.set(
    -- 	"n",
    -- 	"gi",
    -- 	":lua require('telescope.builtin').lsp_implementations({layout_config = {height = 50}}) <cr>",
    -- 	bufopts
    -- )
    vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, bufopts)
    -- vim.keymap.set('n', '<C-p>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "td", vim.lsp.buf.type_definition, bufopts)
    -- vim.keymap.set("n", "td", ":Trouble lsp_type_definitions<CR>", bufopts)
    -- vim.keymap.set(
    -- 	"n",
    -- 	"td",
    -- 	":lua require('telescope.builtin').lsp_type_definitions({layout_config = {height = 50}}) <cr>",
    -- 	bufopts
    -- )
    vim.keymap.set("n", "ds", vim.lsp.buf.document_symbol, bufopts)
    -- vim.keymap.set(
    -- 	"n",
    -- 	"bs",
    -- 	":lua require('telescope.builtin').lsp_document_symbols({layout_config = {height = 50}}) <cr>",
    -- 	bufopts
    -- )
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<A-CR>", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("x", "<A-CR>", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    -- vim.keymap.set("n", "gr", ":Trouble lsp_references<CR>", bufopts)
    -- vim.keymap.set(
    -- 	"n",
    -- 	"gr",
    -- 	":lua require('telescope.builtin').lsp_references({layout_config = {height = 50}}) <cr>",
    -- 	bufopts
    -- )
    --

    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({
            filter = function(c)
                return c.name ~= "tsserver"
                    or c.name ~= "gopls"
                    or c.name ~= "sumneko_lua"
                    or c.name ~= "eslint"
            end,
            async = true,
        })
    end, bufopts)
end

-- Setup lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig")["sumneko_lua"].setup({
    on_attach = on_attach,
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

require("go").setup({
    lint_prompt_style = "vt",
})
require("lspconfig").gopls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    handlers = handlers,
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
            client.server_capabilities.document_formatting = false
        end,
        handlers = handlers,
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
        on_attach(client, bufnr)
        client.server_capabilities.document_formatting = false
    end,
})

require("lspconfig").vuels.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
})

require("lspconfig").html.setup({
    on_attach = on_attach,
    handlers = handlers,
})

require("lspconfig").cssls.setup({
    on_attach = on_attach,
    handlers = handlers,
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

local extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codellb/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

local rust_tools = require("rust-tools")
local rust_analyer_opts = {
    tools = {
        -- how to execute terminal commands
        -- options right now: termopen / quickfix
        executor = require("rust-tools/executors").termopen,

        -- callback to execute once rust-analyzer is done initializing the workspace
        -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
        on_initialized = nil,

        -- These apply to the default RustSetInlayHints command
        inlay_hints = {
            auto = true,

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
            border = border,
            auto_focus = false,
        },
    },

    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        on_init = function(client)
            local cwd = vim.fn.getcwd()
            local local_config_path = cwd .. "/.nvim/rust-analyzer.json"

            local local_config = vim.fn.system("cat " .. local_config_path)

            if string.find(local_config, "No such file or directory") ~= nil then
                return true
            end

            local cfg =
            vim.tbl_deep_extend("force", client.config.settings["rust-analyzer"], vim.fn.json_decode(local_config))
            client.config.settings["rust-analyzer"] = cfg

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            return true
        end,
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            local o = { buffer = bufnr }
            vim.keymap.set("n", "K", rust_tools.hover_actions.hover_actions, o)
            vim.keymap.set("x", "<S-CR>", rust_tools.code_action_group.code_action_group, o)
            vim.keymap.set("n", "<S-CR>", rust_tools.code_action_group.code_action_group, o)
            -- vim.keymap.set("n", "<C-S-k>", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
            -- vim.keymap.set("n", "<leader>a", rust_tools.code_action_group.code_action_group, { buffer = bufnr })
        end,
        handlers = handlers,
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
                    features = {},
                    noDefaultFeatures = false,
                    allFeatures = false,
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
rust_tools.setup(rust_analyer_opts)

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

return M
