require("packer").startup(function()
	use("wbthomason/packer.nvim")

	use("lewis6991/impatient.nvim")
	use("folke/tokyonight.nvim")

	use("nvim-tree/nvim-web-devicons")
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
	})
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	})

	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("tpope/vim-commentary")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-refactor")
	use("nvim-treesitter/nvim-treesitter-context")
	use("nvim-lualine/lualine.nvim")
	use("p00f/nvim-ts-rainbow")
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-file-browser.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("windwp/nvim-ts-autotag")
	use("windwp/nvim-autopairs")
	use("lewis6991/gitsigns.nvim")
	use("SmiteshP/nvim-navic")
	use("stevearc/dressing.nvim")
	use("folke/trouble.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("https://gitlab.com/yorickpeterse/nvim-pqf")
	use("phaazon/hop.nvim")
	use("RRethy/vim-illuminate")
	use("nvimtools/none-ls.nvim")
	use("kylechui/nvim-surround")
	use("nvim-lua/plenary.nvim")
	use("j-hui/fidget.nvim")
	use({ "akinsho/bufferline.nvim", tag = "v3.*", requires = { "nvim-tree/nvim-web-devicons" } })
	use({ "mbbill/undotree" })

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
	use("lvimuser/lsp-inlayhints.nvim")

	-- dap
	use("mfussenegger/nvim-dap")
	use("theHamsta/nvim-dap-virtual-text")
	use({ "rcarriga/nvim-dap-ui" })
	use("leoluz/nvim-dap-go")
	use("mxsdev/nvim-dap-vscode-js")

	use({ "mrcjkb/rustaceanvim", tag = "4.*" })
	-- languages
	use("saecki/crates.nvim")
	use("crispgm/nvim-go")
	use("mfussenegger/nvim-jdtls")
	use("akinsho/flutter-tools.nvim")
	use("b0o/schemastore.nvim")
	use("jose-elias-alvarez/typescript.nvim")

	-- dashboard & sessions
	use("goolord/alpha-nvim")
	use("Shatur/neovim-session-manager")

	-- git
	use("sindrets/diffview.nvim")
	use("tpope/vim-fugitive")
end)

local autopairs = require("nvim-autopairs")
autopairs.setup({})
-- local Rule = require("nvim-autopairs.rule")

-- autopairs.add_rules({
-- 	Rule("%<%>$", "</>", { "typescript", "typescriptreact", "javascript", "javascriptreact" }):use_regex(true),
-- })

---@diagnostic disable-next-line: missing-fields
require("nvim-surround").setup({})
require("dressing").setup({
	input = {
		win_options = {
			-- Window transparency (0-100)
			winblend = 20,
			-- Change default highlight groups (see :help winhl)
			-- winhighlight = "NormalFloat guibg=NONE",
		},
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

local function get_version()
	local cmd = vim.api.nvim_parse_cmd("version", {})
	local output = vim.api.nvim_cmd(cmd, { output = true })
	local list = vim.split(output, "\n")
	local versions = {}
	for index, value in ipairs(list) do
		if value ~= "" and index < 5 then
			table.insert(versions, value)
		end
	end

	return vim.fn.join(versions, "\n")
end

dashboard.section.buttons.val = {
	dashboard.button("e", "  New file", ":ene <BAR> startinsert<CR>"),
	-- dashboard.button("tf", "  Find file", ":Telescope find_files<CR>"),
	-- dashboard.button("tg", "  Find text", ":Telescope live_grep<CR>"),
	-- dashboard.button("tr", "  Recently used files", ":Telescope oldfiles<CR>"),
	dashboard.button("te", "  Open file browser", ":Telescope file_browser<CR>"),
	dashboard.button("tt", "λ  Terminal", ":terminal<CR>"),
	-- dashboard.button("te", "  Open file explorer", ":Ex<CR>"),
	dashboard.button("os", "⌥  Open session", ":SessionManager load_session<CR>"),
	dashboard.button("ol", "  Open last session", ":SessionManager load_last_session<CR>"),
	-- dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua<CR>"),
	dashboard.button("q", "  Quit NVIM", ":qa<CR>"),
}

dashboard.section.footer.val = get_version()

require("session_manager").setup({
	autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
})

alpha.setup(dashboard.config)

require("crates").setup({
	null_ls = {
		enabled = true,
	},
})

require("ibl").setup({
	scope = {
		include = {
			node_type = { lua = { "return_statement", "table_constructor" } },
		},
	},
})

require("pqf").setup({
	signs = { Error = "", Warn = "", Hint = "", Info = "" },
})

require("hop").setup()

require("fidget").setup({
	notification = {
		window = {
			winblend = 0,
		},
	},
})

---@diagnostic disable-next-line: missing-fields
require("ts_context_commentstring").setup({})
