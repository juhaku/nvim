return require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'shaunsingh/nord.nvim'

    use 'kyazdani42/nvim-web-devicons'
    use 'kyazdani42/nvim-tree.lua'

    use 'tpope/vim-commentary'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
end)
