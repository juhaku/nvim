local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
keymap.set("n", "<leader>n", ":nohl<CR>", opts)
keymap.set("n", "<leader>w", ":w<CR>", opts)

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
