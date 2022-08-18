-- global options
vim.g.mapleader = " "

if vim.g.neovide == false then
	vim.g.tokyonight_transparent = true
	vim.g.tokyonight_transparent_sidebar = true
else
	-- neovide options
	-- TODO blur not working
	vim.g.neovide_transparency = 0.8
	vim.g.neovide_remember_window_size = true
	vim.g.neovide_floating_blur_amount_x = 7.0
	vim.g.neovide_floating_blur_amount_y = 7.0
	vim.g.floating_opacity = 0.8
	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_cursor_vfx_particle_density = 8.0
end

vim.g.tokyonight_style = "night"
vim.g.tokyonight_dark_float = false

-- cmds
vim.cmd([[colorscheme tokyonight]])
-- vim.cmd([[
--     highlight FloatBorder guibg=NONE
--     highlight NormalFloat guibg=NONE
-- ]])

-- vim ui options
-- vim.ui.select = require"popui.ui-overrider"
-- vim.ui.input = require"popui.input-overrider"

-- options
local options = vim.opt

options.winblend = 20
options.pumblend = 20
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
options.guifont = "Hack Nerd Font:h10"
options.wrap = false
