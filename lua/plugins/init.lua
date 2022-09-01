require("packer").startup(function()
	use("wbthomason/packer.nvim")

	use("lewis6991/impatient.nvim")
	use("folke/tokyonight.nvim")

	use("kyazdani42/nvim-web-devicons")
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	})

	use("tpope/vim-commentary")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-refactor")
	use("nvim-treesitter/nvim-treesitter-context")
	use("nvim-lualine/lualine.nvim")
	use("p00f/nvim-ts-rainbow")
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-file-browser.nvim")
	use("windwp/nvim-ts-autotag")
	use("windwp/nvim-autopairs")
	use("lewis6991/gitsigns.nvim")
	use("SmiteshP/nvim-navic")
	use("stevearc/dressing.nvim")
	use("folke/trouble.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("https://gitlab.com/yorickpeterse/nvim-pqf")
	use("phaazon/hop.nvim")

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
	use("saecki/crates.nvim")
	use("b0o/schemastore.nvim")

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

	-- dashboard & sessions
	use("goolord/alpha-nvim")
	use("Shatur/neovim-session-manager")

	-- git
	use("sindrets/diffview.nvim")
	use("tpope/vim-fugitive")
end)

local autopairs = require("nvim-autopairs")
autopairs.setup({})
local Rule = require("nvim-autopairs.rule")

autopairs.add_rules({
	Rule("%<%>$", "</>", { "typescript", "typescriptreact", "javascript", "javascriptreact" }):use_regex(true),
})

require("nvim-surround").setup({})
require("dressing").setup({
	input = {
		-- Window transparency (0-100)
		winblend = 20,
		-- Change default highlight groups (see :help winhl)
		-- winhighlight = "NormalFloat guibg=NONE",
	},
	select = {
		enabled = true,
		winblend = 20,
		backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

		get_config = function(opts)
			if opts.kind == "codeaction" then
				return {
					backend = "builtin",
					builtin = {
						min_height = { 0., 0. },
						relative = "cursor",
					},
				}
			end
		end,
	},
})
require("trouble").setup({})

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.buttons.val = {
	dashboard.button("e", "  New file", ":ene <BAR> startinsert<CR>"),
	dashboard.button("tf", "  Find file", ":Telescope find_files<CR>"),
	dashboard.button("tg", "  Find text", ":Telescope live_grep<CR>"),
	dashboard.button("tr", "  Recently used files", ":Telescope oldfiles<CR>"),
	dashboard.button("te", "  Open file browser", ":Telescope file_browser<CR>"),
	dashboard.button("os", "  Open session", ":SessionManager load_session<CR>"),
	dashboard.button("ol", "  Open last session", ":SessionManager load_last_session<CR>"),
	dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua<CR>"),
	dashboard.button("q", "  Quit NVIM", ":qa<CR>"),
}

require("session_manager").setup({
	autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
})

alpha.setup(dashboard.config)

require("crates").setup({
	null_ls = {
		enabled = true,
	},
})

require("indent_blankline").setup({
	show_current_context = true,
	show_current_context_start = false,
	indent_blankline_use_treesitter_scope = true,
})

require("pqf").setup({
	signs = { Error = "", Warn = "", Hint = "", Info = "" },
})

require("hop").setup()
