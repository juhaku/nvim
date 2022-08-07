-- global options
vim.g.mapleader = " "
-- vim.g.tokyodark_transparent_background = true
-- vim.g.tokyodark_enable_italic_comment = true
-- vim.g.tokyodark_enable_italic = false
-- vim.g.tokyodark_color_gamma = "1.0"
vim.g.tokyonight_transparent = true
vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_style = "night"
vim.g.tokyonight_dark_float = false

-- cmds
vim.cmd([[colorscheme tokyonight]])

-- vim ui options
-- vim.ui.select = require"popui.ui-overrider"
-- vim.ui.input = require"popui.input-overrider"

-- options
local options = vim.opt

options.completeopt = "menu,menuone,preview,noselect"
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
-- options.showtabline = 1 -- default 1, show when there are at least one
options.softtabstop = 4
options.smarttab = true
options.smartcase = true
options.fileencoding = "utf-8"
options.termguicolors = true
options.splitbelow = true
options.splitright = true
options.cursorline = true
options.hidden = true
options.autoindent = true
--options.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"
options.virtualedit = "block"
options.guifont = "Hack Nerd Font:h10"