-- global options
vim.g.mapleader = " "

if vim.g.neovide then
	require("neovide-config")
end

-- options
local options = vim.opt

options.cmdheight = 1
options.showmode = false
options.winblend = 20
options.pumblend = 20
options.completeopt = "menu,menuone,preview,noinsert,noselect"
options.syntax = "on"
options.scrolloff = 8
options.scrolloff = 8
options.number = true
options.relativenumber = true
options.ignorecase = true
options.hlsearch = true
options.incsearch = true
options.clipboard = "unnamedplus"
options.laststatus = 3
options.tabstop = 4
options.expandtab = true
options.shiftwidth = 4
options.showtabline = 2 -- default 1, show when there are at least one
options.softtabstop = 4
options.smarttab = true
options.smartcase = true
options.smartindent = true
options.breakindent = true
options.fileencoding = "utf-8"
options.termguicolors = true
options.splitbelow = true
options.splitright = true
options.cursorline = true
options.hidden = true
options.autoindent = true
--options.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
options.virtualedit = "block"
options.guifont = "Hack Nerd Font:h8"
options.wrap = false
options.mouse = "a"
