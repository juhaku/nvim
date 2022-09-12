-- cache for faster startup
require("impatient")
-- core
require("colors")
require("core_options")
require("core_keymap")
require("git_commands")

-- plugins
require("plugins")
require("plugins.mason_config")
require("plugins.diffview-config")
require("plugins.neo-tree-config")
-- require("plugins.nvim-tree-config")
require("plugins.lualine-config")
require("plugins.telescope-config")
-- require('plugins.fzf-lua-config')
require("plugins.treesitter-config")
require("plugins.gitsigns-config")
require("plugins.cmp-config")
require("plugins.lsp-config")
require("plugins.dap-config")
require("plugins.null-ls-config")
