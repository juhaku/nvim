return {
	"nvim-lua/plenary.nvim",
	config = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "PlenaryLoaded" })
	end,
}
