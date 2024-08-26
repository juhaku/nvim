return {
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()

			vim.keymap.set("n", "<F9>", function()
				dap.continue()
			end)
			vim.keymap.set("n", "<F8>", function()
				dap.terminate()
			end)
			vim.keymap.set("n", "<F10>", function()
				dap.step_over()
			end)
			vim.keymap.set("n", "<F11>", function()
				dap.step_into()
			end)
			vim.keymap.set("n", "<F12>", function()
				dap.step_out()
			end)
			vim.keymap.set("n", "<leader>b", function()
				dap.toggle_breakpoint()
			end)
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint()
			end)
			-- use commands instead
			-- vim.keymap.set("n", "<leader>bc", function()
			-- 	vim.ui.input({ prompt = "Condition: " }, function(input)
			-- 		dap.set_breakpoint(input, nil, nil)
			-- 	end)
			-- end)
			-- vim.keymap.set("n", "<leader>bh", function()
			-- 	vim.ui.input({ prompt = "Hit count: " }, function(input)
			-- 		dap.set_breakpoint(nil, input, nil)
			-- 	end)
			-- 	-- dap.set_breakpoint(nil, vim.ui.input("Hit count: "), nil)
			-- end)
			-- vim.keymap.set("n", "<Leader>bl", function()
			-- 	vim.ui.input({ prompt = "Log point message: " }, function(input)
			-- 		dap.set_breakpoint(nil, nil, input)
			-- 	end)
			-- 	-- dap.set_breakpoint(nil, nil, vim.ui.input("Log point message: "))
			-- end)
			vim.keymap.set("n", "<leader>dr", function()
				dap.repl.open()
			end)
			vim.keymap.set("n", "<leader>dl", function()
				dap.run_last()
			end)
			-- vim.keymap.set("n", "<leader>bL", function()
			-- 	vim.cmd([[botright copen]])
			-- 	dap.list_breakpoints()
			-- end)
			vim.keymap.set("n", "<leader>cb", function()
				dap.clear_breakpoints()
			end)
			vim.keymap.set({ "n", "v" }, "<leader>dh", function()
				require("dap.ui.widgets").hover()
			end)
			vim.keymap.set({ "n", "v" }, "<leader>dp", function()
				require("dap.ui.widgets").preview()
			end)
			vim.keymap.set("n", "<leader>df", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end)
			vim.keymap.set("n", "<leader>ds", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end)

			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

			vim.api.nvim_create_user_command("DapBreakpointCondition", function()
				vim.ui.input({ prompt = "Condition: " }, function(input)
					dap.set_breakpoint(input, nil, nil)
				end)
			end, {})
			vim.api.nvim_create_user_command("DapBreakpointHitCount", function()
				vim.ui.input({ prompt = "Hit count: " }, function(input)
					dap.set_breakpoint(nil, input, nil)
				end)
			end, {})
			vim.api.nvim_create_user_command("DapBreakpointLog", function()
				vim.ui.input({ prompt = "Log message: " }, function(input)
					dap.set_breakpoint(nil, nil, input)
				end)
			end, {})

			vim.api.nvim_create_user_command("DapListBreakpoints", function()
				vim.cmd([[botright copen]])
				dap.list_breakpoints()
			end, {})
			vim.api.nvim_create_user_command("DapClearBreakpoints", dap.clear_breakpoints, {})
			vim.api.nvim_create_user_command("DapUiToggle", function()
				require("dapui").toggle()
			end, {})
			-- dap.listeners.before.attach.dapui_config = function()
			-- 	dapui.open()
			-- end
			-- dap.listeners.before.launch.dapui_config = function()
			-- 	dapui.open()
			-- end
			-- dap.listeners.before.event_terminated.dapui_config = function()
			-- 	dapui.close()
			-- end
			-- dap.listeners.before.event_exited.dapui_config = function()
			-- 	dapui.close()
			-- end
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap" },
		config = true,
	},
}
