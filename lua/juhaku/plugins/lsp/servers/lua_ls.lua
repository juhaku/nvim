return {
	settings = {
		Lua = {
			format = {
				enable = false,
			},
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			hint = {
				enable = true,
			},
			workspace = {
				checkThirdParty = false,
				-- Make the server aware of Neovim runtime files
				-- library = vim.api.nvim_get_runtime_file("", true),
				library = {
					vim.fn.expand("$VIMRUNTIME/lua"),
					vim.fn.stdpath("config") .. "/lua",
				},
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
}
