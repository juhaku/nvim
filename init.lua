-- global options
vim.g.mapleader = ' '
vim.g.tokyodark_transparent_background = true
vim.g.tokyodark_enable_italic_comment = true
vim.g.tokyodark_enable_italic = false
vim.g.tokyodark_color_gamma = "1.0"

-- cmds
vim.cmd("colorscheme tokyodark")

-- vim ui options
-- vim.ui.select = require"popui.ui-overrider"
-- vim.ui.input = require"popui.input-overrider"

-- options
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
options.virtualedit = "block"
options.guifont="Hack Nerd Font:h10"

-- -- keymaps
local keymap = vim.keymap
local opts = {noremap = true, silent = true}

keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', opts)
keymap.set('n', '<leader>n', ':nohl<CR>', opts)
keymap.set('n', '<leader>w', ':w<CR>', opts)
keymap.set({'n', 'i', 'v', 'c'}, '<C-S-tab>', ':bp<CR>', opts)
keymap.set({'n', 'i', 'v', 'c'}, '<C-tab>', ':bn<CR>', opts)
keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')
keymap.set('n', '<C-S-n>', ':Telescope find_files<CR>')
keymap.set('n', '<leader>tq', ':bdelete<CR> :bprevious<CR>')
-- keymap.set('n', ',d', ':lua require'popui.diagnostics-navigator'\(\)<CR>', opts)
-- nnoremap <leader>ff <cmd>Telescope find_files<cr>
-- nnoremap <leader>fg <cmd>Telescope live_grep<cr>
-- nnoremap <leader>fb <cmd>Telescope buffers<cr>
-- nnoremap <leader>fh <cmd>Telescope help_tags<cr>

-- -- require modules
require('plugins')
require('plugins.nvim-tree-config')
require('plugins.lualine-config')
require('plugins.telescope-config')
-- require('plugins.fzf-lua-config')
require('plugins.treesitter-config')
require('plugins.gitsigns-config')
require('plugins.rust-analyzer-config')
require('plugins.cmp-config')

-- -- cmds
-- vim.cmd[[colorscheme nord]]

-- old vim script style configurations
--syntax on
--set scrolloff=8
--" Do incremental searching.
--set incsearch
--set hlsearch
--set nu
--set rnu
--set ignorecase
--set clipboard=unnamedplus
--set laststatus=3
--set tabstop=4
--
--
--
--
--
--
--
--
--
--
