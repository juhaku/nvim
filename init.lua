local options = vim.opt

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
options.fileencoding = 'utf-8'
options.termguicolors = true
options.splitbelow = true
options.splitright = true --options.cursorline = true -- highlight cursor line options.hidden = true options.autoindent = true
--options.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.g.mapleader = ' '
local keys = vim.api.nvim_set_keymap

local opts = {noremap = true, silent = true}
keys('n', '<leader>e', ':NvimTreeToggle<CR>', opts)
keys('n', '<leader>n', ':nohl<CR>', opts)
keys('n', '<leader>w', ':w<CR>', opts)


require('plugins')
require('nvim-tree-config')

vim.cmd[[colorscheme nord]]


-- old vim script style configurations
--syntax on
--set scrolloff=8
--" Do incremental searching.
--set incsearch
----set hlsearch
--set nu
--set rnu
--set ignorecase
--set clipboard=unnamedplus
--set laststatus=3
--set tabstop=4
