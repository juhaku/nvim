require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    -- use 'shaunsingh/nord.nvim'

    use 'kyazdani42/nvim-web-devicons'
    use 'kyazdani42/nvim-tree.lua'

    use 'tpope/vim-commentary'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'nvim-treesitter/nvim-treesitter-refactor'
    use 'nvim-lualine/lualine.nvim'
    use 'p00f/nvim-ts-rainbow'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim' 
    use 'ibhagwan/fzf-lua'
    use 'windwp/nvim-ts-autotag'
    use 'windwp/nvim-autopairs'
    use 'lewis6991/gitsigns.nvim'

    use 'neovim/nvim-lspconfig'
    use 'simrat39/rust-tools.nvim'
    use 'mfussenegger/nvim-dap'
end)

require('nvim-autopairs').setup{}
require'nvim-treesitter.configs'.setup {
  autotag = {
    enable = true,
  }
}

