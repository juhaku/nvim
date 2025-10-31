return {
	"mrcjkb/rustaceanvim",
	version = "^6",
	config = function()
		vim.g.rustaceanvim = {
			tools = {
				float_win_config = {
					border = require("global").border,
				},
				test_executor = "termopen",
			},
			server = {
				on_attach = function(client, bufnr)
					require("juhaku.plugins.lsp").on_attach(client, bufnr)

					local opts = { silent = true, buffer = bufnr }
					vim.keymap.set("n", "K", function()
						vim.cmd.RustLsp({ "hover", "actions" })
					end, opts)
					-- vim.keymap.set("n", "<A-CR>", function()
					-- 	vim.cmd.RustLsp("codeAction")
					-- end, opts)
				end,
				settings = function(project_root)
					local rust_analyzer_settings = project_root .. "/.nvim/rust-analyzer.json"
					local default_config = require("rustaceanvim.config.internal")
					local default_settings = default_config.server.default_settings

					local has_project_settings =
						tonumber(vim.fn.system("test -f " .. rust_analyzer_settings .. " && echo 1"))
					if has_project_settings == 1 then
						vim.notify("found ./nvim/rust-analyzer.json project settings", vim.log.levels.DEBUG)
						local content = vim.fn.system("cat " .. rust_analyzer_settings)
						local success, json = pcall(vim.fn.json_decode, content)
						if success then
							-- merge default config with the project settings
							local merged_config = {
								["rust-analyzer"] = vim.tbl_deep_extend(
									"force",
									default_settings["rust-analyzer"],
									json
								),
							}
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
						check = {
							command = "clippy",
						},
						completion = {
							fullFunctionSignatures = {
								enable = true,
							},
						},
					},
				},
			},
		}
	end,
}
