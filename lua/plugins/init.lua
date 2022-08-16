require("packer").startup(function()
	use("wbthomason/packer.nvim")

	use("lewis6991/impatient.nvim")
	-- use 'shaunsingh/nord.nvim'
	-- use 'tiagovla/tokyodark.nvim'
	use("folke/tokyonight.nvim")

	use("kyazdani42/nvim-web-devicons")
	-- use("kyazdani42/nvim-tree.lua")
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	})
	-- popui
	-- use 'RishabhRD/popfix'
	-- use 'hood/popui.nvim'

	use("tpope/vim-commentary")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-refactor")
	use("nvim-lualine/lualine.nvim")
	use("p00f/nvim-ts-rainbow")
	use("nvim-telescope/telescope.nvim")
	-- use 'nvim-telescope/telescope-ui-select.nvim'
	-- use 'ibhagwan/fzf-lua'
	use("windwp/nvim-ts-autotag")
	use("windwp/nvim-autopairs")
	use("lewis6991/gitsigns.nvim")
	use("SmiteshP/nvim-navic")
	use("stevearc/dressing.nvim")

	-- cmp plugins
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/nvim-cmp")
	use("onsails/lspkind.nvim")

	-- lua snippets
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")

	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("neovim/nvim-lspconfig")
	use("simrat39/rust-tools.nvim")

	use("RRethy/vim-illuminate")
	use("jose-elias-alvarez/null-ls.nvim")
	use("kylechui/nvim-surround")
	use("nvim-lua/plenary.nvim")
	use("mfussenegger/nvim-dap")
	use("theHamsta/nvim-dap-virtual-text")
	use("rcarriga/nvim-dap-ui")
	use("leoluz/nvim-dap-go")
	-- use("David-Kunz/jester")
	--
	use("jose-elias-alvarez/typescript.nvim")
	use("crispgm/nvim-go")
end)

require("mason").setup({
	ui = {
		border = {
			{ "╭", "FloatBorder" },
			{ "─", "FloatBorder" },
			{ "╮", "FloatBorder" },
			{ "│", "FloatBorder" },
			{ "╯", "FloatBorder" },
			{ "─", "FloatBorder" },
			{ "╰", "FloatBorder" },
			{ "│", "FloatBorder" },
		},
	},
})
require("mason-lspconfig").setup()
require("nvim-autopairs").setup({})
require("nvim-treesitter.configs").setup({
	autotag = {
		enable = true,
	},
})
require("nvim-surround").setup({})
require("dressing").setup({
	input = {
		-- Window transparency (0-100)
		-- winblend = 50,
		-- Change default highlight groups (see :help winhl)
		-- winhighlight = "NormalFloat guibg=NONE",
	},
})
