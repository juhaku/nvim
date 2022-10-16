local dap = require("dap")
local dapui = require("dapui")
require("nvim-dap-virtual-text").setup()
require("dap-go").setup()
-- require("jester").setup({
-- 	cmd = "yarn jest -t '$result' -- $file",
-- 	dap = {
-- 		console = "externalTerminal",
-- 	},
-- })
--
local home = os.getenv("HOME")

dap.adapters.node2 = {
	type = "executable",
	command = "node",
	args = { os.getenv("HOME") .. "/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
}

local dap_vscode_path = home .. "/.local/share/nvim/mason/packages/js-debug-adapter"

require("dap-vscode-js").setup({
	-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
	-- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
	debugger_path = dap_vscode_path,
	-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
})

for _, language in ipairs({ "typescript", "javascript" }) do
	dap.configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Debug Jest Tests",
			-- trace = true, -- include debugger info
			runtimeExecutable = "node",
			runtimeArgs = {
				"./node_modules/.bin/jest",
				"--runInBand",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
		},
	}
end

-- for _, language in ipairs({ "typescript", "javascript" }) do
-- 	dap.configurations[language] = {
-- 		{
-- 			type = "node2",
-- 			request = "launch",
-- 			name = "Launch file",
-- 			program = "${file}",
-- 			cwd = "${workspaceFolder}",
-- 			sourceMaps = true,
-- 			protocol = "inspector",
-- 			console = "integratedTerminal",
-- 		},
-- 		{
-- 			type = "node2",
-- 			request = "attach",
-- 			name = "Attach",
-- 			processId = require("dap.utils").pick_process,
-- 			cwd = "${workspaceFolder}",
-- 		},
-- 		{
-- 			type = "node2",
-- 			request = "launch",
-- 			name = "Debug Jest Tests",
-- 			-- trace = true, -- include debugger info
-- 			runtimeExecutable = "node",
-- 			runtimeArgs = {
-- 				"${workspaceFolder}/node_modules/.bin/jest",
-- 				"--runInBand",
-- 			},
-- 			rootPath = "${workspaceFolder}",
-- 			sourceMaps = true,
-- 			cwd = "${workspaceFolder}",
-- 			-- console = "integratedTerminal",
-- 			-- internalConsoleOptions = "neverOpen",
-- 			skipFiles = { "<node_internals>/**", "node_modules/**" },
-- 		},
-- 	}
-- end

dapui.setup()
-- dapui.setup({
-- 	-- sidebar = {
-- 	-- 	elements = {
-- 	-- 		{
-- 	-- 			id = "scopes",
-- 	-- 			size = 0.25, -- Can be float or integer > 1
-- 	-- 		},
-- 	-- 		{ id = "breakpoints", size = 0.25 },
-- 	-- 	},
-- 	-- 	size = 40,
-- 	-- 	position = "right", -- Can be "left", "right", "top", "bottom"
-- 	-- },
-- 	-- tray = {
-- 	-- 	elements = {},
-- 	-- },
-- })

-- vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
