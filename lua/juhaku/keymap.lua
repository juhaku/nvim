local utils = require("juhaku.utils")
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- -- core
-- keymap.set("n", "<leader>e", ":Neotree filesystem toggle left<CR>")
keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<CR>", opts)
keymap.set("n", "<leader>n", ":nohl<CR>", opts)
keymap.set("n", "<leader>w", ":w<CR>", opts)
keymap.set("n", "vae", "gg<S-v>G", opts) -- visual select all
keymap.set("n", "QQ", ":qa<CR>", opts)
keymap.set("n", "<leader>qa", ":qa<CR>", opts)
keymap.set("n", "<leader>qm", ":to<CR><CMD>Alpha<CR>", opts)
keymap.set("n", "<leader>ut", function()
	local undotree_open = utils.is_window_open_by_name_pattern("undotree")
	if undotree_open then
		vim.cmd(":UndotreeHide")
	else
		vim.cmd([[
            UndotreeShow
            UndotreeFocus
        ]])
	end
end)
keymap.set({ "n", "v" }, "<leader>y", '"+y', opts)
keymap.set({ "n", "v" }, "<leader>c", '"+c', opts)
keymap.set({ "n", "v" }, "<leader>x", '"+x', opts)
keymap.set({ "n", "v" }, "<leader>d", '"+d', opts)
keymap.set({ "n", "v" }, "<leader>p", '"+p', opts)
keymap.set({ "n", "v" }, "<leader>P", '"+P', opts)
keymap.set("i", "<A-d>", '<C-o>"_dw')
keymap.set({ "i", "c" }, "<A-BS>", "<C-w>")
keymap.set({ "i", "c" }, "<A-h>", "<C-w>")

-- keymap.set({ "n", "i", "v", "x", "c" }, "<Bslash><Bslash>", "<Esc>", opts)
keymap.set("i", "<C-c>", "<Esc>", opts)
-- TODO filter quicfix list based on ignored files
keymap.set("n", "<C-n>", ":cnext<CR>zz", opts)
keymap.set("n", "<C-p>", ":cprev<CR>zz", opts)
keymap.set("n", "<C-S-n>", ":lnext<CR>zz", opts)
keymap.set("n", "<C-S-p>", ":lprev<CR>zz", opts)

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")
keymap.set({ "n", "v" }, "<A-p>", "pgvy`.")
keymap.set({ "n", "v" }, "<A-S-P>", "Pgvy`.")
keymap.set({ "n", "v" }, "x", '"_x')
keymap.set({ "n", "v" }, "X", '"_X')
keymap.set("n", "<leader>dv", ":Gdiffsplit!<CR>", opts)
keymap.set("n", "<leader>gb", ":G blame<CR>", opts)

-- neovide paste in neovide below 10.3
if vim.g.neovide ~= nil then
	local global = require("global")
	if global.is_mac() then
        keymap.set({ "c", "i" }, "<D-v>", '<C-r>"', {})
		keymap.set("n", "<D-v>", '"+p', {})
	else
		keymap.set({ "c", "i" }, "<C-S-v>", '<C-r>"', {})
		keymap.set("n", "<C-S-v>", '"+p', {})
	end
end

-- session manager
keymap.set("n", "<leader>os", ":SessionManager load_session<CR>", opts)
keymap.set("n", "<leader>sw", ":SessionManager save_current_session<CR>", opts)

-- resize splits
keymap.set("n", "<C-Left>", "<C-w><", opts)
keymap.set("n", "<C-Right>", "<C-w>>", opts)
keymap.set("n", "<C-Up>", "<C-w>+", opts)
keymap.set("n", "<C-Down>", "<C-w>-", opts)

-- alt move selected lines
keymap.set("n", "<A-j>", ":m .+1<CR>==", opts)
keymap.set("n", "<A-k>", ":m .-2<CR>==", opts)
keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

--- tabs
keymap.set({ "n", "i", "v", "c" }, "<C-S-tab>", ":tabprev<CR>", opts)
keymap.set({ "n", "i", "v", "c" }, "<C-tab>", ":tabnext<CR>", opts)
keymap.set({ "n", "i", "v", "c" }, "<A-o>", ":tabprev<CR>", opts)
keymap.set({ "n", "i", "v", "c" }, "<A-i>", ":tabnext<CR>", opts)
keymap.set("n", "<C-w>t", ":tabnew %<CR>", opts)
keymap.set("n", "<leader>tn", ":tabnew<CR>", opts)
keymap.set("n", "<leader>to", ":tabonly<CR>", opts)
keymap.set("n", "<leader>tc", ":tabclose<CR>", opts)

-- Telescope
keymap.set("n", "<leader>tf", ":Telescope find_files<CR>", opts)
-- keymap.set("n", "te", ":Telescope file_browser<CR>", opts)
keymap.set("n", "<leader>ta", ":lua require('telescope.builtin').find_files({hidden=true, no_ignore=true})<CR>", opts)
keymap.set("n", "<leader>tF", function()
	require("telescope.builtin").find_files({
		find_command = function()
			return {
				"fd",
				"--type",
				"f",
				"--color",
				"never",
				"--exclude",
				".git",
				"--hidden",
				"--follow",
				"--no-ignore",
			}
		end,
	})
end, opts)
keymap.set("n", "<leader>tg", ":Telescope live_grep<CR>", opts)
keymap.set("n", "<leader>tG", function()
	require("telescope.builtin").live_grep({
		additional_args = function()
			return { "--hidden" }
		end,
	})
end, opts)
keymap.set("n", "<leader>tB", ":Telescope buffers<CR>", opts)
-- Dap keybindings
-- keymap.set("n", "<leader>dl", ":lua lua require('dap').run_last()<CR>", opts)
-- keymap.set("n", "<F12>", ":lua require('dapui').close()<CR>", opts)

-- terminal
keymap.set("n", "<leader>tx", ":split | terminal<CR>", opts)
keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>", opts)
keymap.set("n", "<leader>tt", ":tabnew | terminal<CR>", opts)

keymap.set("t", "<Esc>", "<C-\\><C-n>", opts)
keymap.set("t", "<A-\\>", "<C-\\><C-n>", opts)
-- keymap.set("t", "<A-w>q", "<C-\\><C-n><C-w>q", opts)

-- keymap.set("t", "<A-w>k", "<C-\\><C-n><C-w>k", opts)
-- keymap.set("t", "<A-w>j", "<C-\\><C-n><C-w>j", opts)
-- keymap.set("t", "<A-w>l", "<C-\\><C-n><C-w>l", opts)
-- keymap.set("t", "<A-w>h", "<C-\\><C-n><C-w>h", opts)

keymap.set("n", "<leader>x.", ":split | Oil<CR>", opts)
keymap.set("n", "<leader>v.", ":vsplit | Oil<CR>", opts)
keymap.set("n", "<leader>t.", ":tabnew | Oil<CR>", opts)
keymap.set("n", "<leader>.", ":Oil --float<CR>", opts)

vim.api.nvim_create_autocmd({ "TermOpen" }, {
	pattern = { "*" },
	command = [[
        setlocal nospell
        startinsert
    ]],
})

vim.api.nvim_create_user_command("Tig", function(o)
	local cmd = "tabnew | terminal tig " .. o.args
	vim.cmd(cmd)
end, {
	nargs = "?",
	complete = function()
		return { "--all" }
	end,
})

vim.api.nvim_create_user_command("Stig", function(o)
	local cmd = "split | terminal tig " .. o.args
	vim.cmd(cmd)
end, {
	nargs = "?",
	complete = function()
		return { "--all" }
	end,
})

vim.api.nvim_create_user_command("Fgl", function(o)
	local zshrc = os.getenv("HOME") .. "/.zshrc"
	local filename = vim.fn.expand("%")

	if o.bang == true then
		vim.cmd("tabnew | terminal source " .. zshrc .. "; fgl --follow -- " .. filename)
	else
		vim.cmd("tabnew | terminal source " .. zshrc .. "; fgl")
	end
end, {
	bang = true,
})

vim.api.nvim_create_user_command("Wx", function(o)
	local cmd = "tabnew | terminal watchmux "
	if o.args ~= "" then
		cmd = cmd .. "-c " .. o.args
	end
	vim.cmd(cmd)
end, {
	nargs = "?",
	complete = "file",
})

local function live_grep(o, args)
	if o.args ~= "" then
		args = vim.tbl_deep_extend("force", args, {
			search_dirs = { o.args },
		})
	end

	require("telescope.builtin").live_grep(args)
end

vim.api.nvim_create_user_command("Grep", function(o)
	live_grep(o, {})
end, {
	nargs = "?",
	complete = "dir",
})

vim.api.nvim_create_user_command("GrepHidden", function(o)
	live_grep(o, { "--hidden" })
end, {
	nargs = "?",
	complete = "dir",
})

vim.api.nvim_create_user_command("GrepAll", function(o)
	local grep_all_args = {
		additional_args = { "--hidden", "--no-ignore" },
	}
	live_grep(o, grep_all_args)
end, {
	nargs = "?",
	complete = "dir",
})
