local global = require("global")

require("juhaku.options")
require("juhaku.keymap")
require("juhaku.git_commands")
require("juhaku.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "juhaku.plugins" },
	},
	ui = {
		border = global.border,
	},
	install = {
		colorscheme = { "tokyonight", "default" },
	},
	change_detection = {
		enabled = true,
		notify = false,
	},
})
