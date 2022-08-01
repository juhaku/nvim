require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    -- use 'shaunsingh/nord.nvim'
    use 'tiagovla/tokyodark.nvim'

    use 'kyazdani42/nvim-web-devicons'
    use 'kyazdani42/nvim-tree.lua'
    -- use 'hood/popui.nvim'

    use 'tpope/vim-commentary'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/nvim-treesitter-refactor'
    use 'nvim-lualine/lualine.nvim'
    use 'p00f/nvim-ts-rainbow'
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-ui-select.nvim'
    -- use 'ibhagwan/fzf-lua'
    use 'windwp/nvim-ts-autotag'
    use 'windwp/nvim-autopairs'
    use 'lewis6991/gitsigns.nvim'

    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lua'

    use 'williamboman/mason.nvim'
    use 'neovim/nvim-lspconfig'
    use 'simrat39/rust-tools.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'mfussenegger/nvim-dap'
end)

require('mason').setup()
require('nvim-autopairs').setup{}
require'nvim-treesitter.configs'.setup {
  autotag = {
    enable = true,
  }
}

