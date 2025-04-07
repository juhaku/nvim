local global = require("global")

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<A-d>", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, opts)
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, opts)
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, opts)

local signs = {}
for type, icon in pairs(global.icons.diagnostic) do
	local hl = "DiagnosticSign" .. type
	local name = type:upper()
	signs.text = vim.tbl_deep_extend("force", signs.text or {}, { [name] = icon })
	signs.numhl = vim.tbl_deep_extend("force", signs.numhl or {}, { [name] = hl })
	signs.linehl = vim.tbl_deep_extend("force", signs.linehl or {}, { [name] = hl })
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local config = {
	virtual_text = true,
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = true,
		style = "minimal",
		border = global.border,
	},
	signs = signs,
}
vim.diagnostic.config(config)
