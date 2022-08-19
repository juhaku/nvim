-- neovide options
-- TODO blur not working
vim.g.neovide_transparency = 0.8
vim.g.neovide_remember_window_size = true
vim.g.neovide_floating_blur_amount_x = 7.0
vim.g.neovide_floating_blur_amount_y = 7.0
vim.g.floating_opacity = 0.8
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_vfx_particle_density = 8.0

vim.opt.guifont = "Hack Nerd Font:h8"
vim.g.gui_font_default_size = 8
vim.g.gui_font_size = vim.g.gui_font_default_size
vim.g.gui_font_face = "Hack Nerd Font"

local refreshGuiFont = function()
	vim.opt.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
end

local resizeGuiFont = function(delta)
	vim.g.gui_font_size = vim.g.gui_font_size + delta
	refreshGuiFont()
end

local resetGuiFont = function()
	vim.g.gui_font_size = vim.g.gui_font_default_size
	refreshGuiFont()
end

-- Call function on startup to set default value
resetGuiFont()

-- Keymaps

local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "i" }, "<C-=>", function()
	resizeGuiFont(1)
end, opts)
vim.keymap.set({ "n", "i" }, "<C-->", function()
	resizeGuiFont(-1)
end, opts)
