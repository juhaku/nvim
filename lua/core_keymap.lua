local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
keymap.set("n", "<leader>n", ":nohl<CR>", opts)
keymap.set("n", "<leader>w", ":w<CR>", opts)

-- resize splits
keymap.set("n", "<C-Left>", "<C-w>>", opts)
keymap.set("n", "<C-Right>", "<C-w><", opts)
keymap.set("n", "<C-Up>", "<C-w>-", opts)
keymap.set("n", "<C-Down>", "<C-w>+", opts)

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

-- Telescope
keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
-- keymap.set('n', '<C-S-n>', ':Telescope find_files<CR>')
keymap.set("n", "<leader>tq", ":bdelete<CR> :bprevious<CR>")
-- keymap.set('n', ',d', ':lua require'popui.diagnostics-navigator'\(\)<CR>', opts)
-- nnoremap <leader>ff <cmd>Telescope find_files<cr>
-- nnoremap <leader>fg <cmd>Telescope live_grep<cr>
-- nnoremap <leader>fb <cmd>Telescope buffers<cr>
-- nnoremap <leader>fh <cmd>Telescope help_tags<cr>

-- Dap keybindings
keymap.set("n", "<leader>b", ":DapToggleBreakpoint<CR>")
keymap.set("n", "<F9>", ":DapContinue<CR>")
keymap.set("n", "<F8>", ":DapStepOver<CR>")
keymap.set("n", "<F10>", ":DapTerminate<CR>")
keymap.set("n", "<F6>", ":DapStepInto<CR>")
keymap.set("n", "<F7>", ":DapStepOut<CR>")
keymap.set("n", "<leader>dr", ":DapToggleRepl<CR>")