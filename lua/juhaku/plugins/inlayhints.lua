return {
	"lvimuser/lsp-inlayhints.nvim",
	config = function()
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

				-- only gopls, java, typescript and rust and lua is handled here
				if
					client.name == "tsserver"
					or client.name == "jdtls"
					or client.name == "gopls"
					or client.name == "rust-analyzer"
					or client.name == "lua_ls"
				then
					require("lsp-inlayhints").on_attach(client, bufnr)
				end
			end,
		})
		vim.cmd("hi LspInlayHint guibg=NONE")
	end,
}
