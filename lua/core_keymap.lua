local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- core
keymap.set("n", "<leader>e", ":Neotree filesystem toggle left<CR>")
-- keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
keymap.set("n", "<leader>n", ":nohl<CR>", opts)
keymap.set("n", "<leader>w", ":w<CR>", opts)
keymap.set("n", "vae", "gg<S-v>G", opts) -- visual select all
keymap.set("n", "QQ", ":qa<CR>", opts)
keymap.set("n", "<leader>qa", ":qa<CR>", opts)
keymap.set("n", "<leader>qm", ":to<CR><CMD>Alpha<CR>", opts)
keymap.set("n", "<leader>ut", ":UndotreeToggle<CR>", opts)

keymap.set("n", "<leader>wf", ":HopPattern<CR>", opts)
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

-- neovide paste in neovide below 10.3
if vim.g.neovide ~= nil then
	keymap.set({ "c", "i" }, "<C-S-v>", '<C-r>"', {})
	keymap.set("n", "<C-S-v>", '"+p', {})
end

-- session manager
keymap.set("n", "<leader>os", ":SessionManager load_session<CR>", opts)
keymap.set("n", "<leader>ws", ":SessionManager save_current_session<CR>", opts)

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
keymap.set("n", "tn", ":tabnew<CR>", opts)
keymap.set("n", "to", ":tabonly<CR>", opts)
keymap.set("n", "tc", ":tabclose<CR>", opts)

-- Telescope
keymap.set("n", "tf", ":Telescope find_files<CR>", opts)
-- keymap.set("n", "te", ":Telescope file_browser<CR>", opts)
keymap.set("n", "tA", ":lua require('telescope.builtin').find_files({hidden=true, no_ignore=true})<CR>", opts)
keymap.set("n", "tF", function()
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
keymap.set("n", "tg", ":Telescope live_grep<CR>", opts)
keymap.set("n", "tG", function()
	require("telescope.builtin").live_grep({
		additional_args = function()
			return { "--hidden" }
		end,
	})
end, opts)
keymap.set("n", "tb", ":Telescope buffers<CR>", opts)
-- keymap.set("n", "fb", ":Telescope file_browser<CR>")
-- keymap.set('n', '<C-S-n>', ':Telescope find_files<CR>')
keymap.set("n", "<leader>tq", ":bdelete<CR> :bprevious<CR>", opts)
-- keymap.set('n', ',d', ':lua require'popui.diagnostics-navigator'\(\)<CR>', opts)
-- nnoremap <leader>ff <cmd>Telescope find_files<cr>
-- nnoremap <leader>fg <cmd>Telescope live_grep<cr>
-- nnoremap <leader>fb <cmd>Telescope buffers<cr>
-- nnoremap <leader>fh <cmd>Telescope help_tags<cr>

-- Dap keybindings
keymap.set("n", "<leader>b", ":DapToggleBreakpoint<CR>", opts)
keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
keymap.set("n", "<leader>bh", ":lua require'dap'.set_breakpoint(nil, vim.fn.input('Hit count: '), nil)<CR>", opts)
keymap.set("n", "<leader>bl", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log message: '))<CR>", opts)
keymap.set("n", "<F9>", ":DapContinue<CR>", opts)
keymap.set("n", "<F8>", ":DapStepOver<CR>", opts)
keymap.set("n", "<F10>", ":DapTerminate<CR>", opts)
keymap.set("n", "<F6>", ":DapStepInto<CR>", opts)
keymap.set("n", "<F7>", ":DapStepOut<CR>", opts)
keymap.set("n", "<leader>dr", ":DapToggleRepl<CR>", opts)
keymap.set(
	"n",
	"<leader>lp",
	":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
	opts
)
keymap.set("n", "<leader>dl", ":lua lua require('dap').run_last()<CR>", opts)
keymap.set("n", "<F12>", ":lua require('dapui').close()<CR>", opts)

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

-- excute checktime command to make vim auto reload file upon external change
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	pattern = { "*" },
	callback = function()
		if vim.mode ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
	pattern = { "*" },
	command = ":startinsert",
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

vim.api.nvim_create_user_command("STig", function(o)
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
