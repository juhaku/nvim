return {
	"akinsho/flutter-tools.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim", -- optional for vim.ui.select
	},
	config = true,
	opts = {
		debugger = {
			enabled = true,
			register_configurations = function()
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
			on_attach = require("juhaku.plugins.lsp").on_attach,
			handlers = require("juhaku.plugins.lsp").handlers,
			capabilities = require("juhaku.plugins.cmp").default_capabilities(),
		},
	},
}
