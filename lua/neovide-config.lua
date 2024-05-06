-- neovide options
vim.g.neovide_transparency = 0.9
vim.g.neovide_remember_window_size = true
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.neovide_cursor_vfx_particle_density = 12.0
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_vfx_opacity = 180.0
vim.g.neovide_cursor_vfx_particle_lifetime = 1.5
vim.g.neovide_cursor_vfx_particle_speed = 12.0

-- railgun only
vim.g.neovide_cursor_vfx_particle_phase = 5.0
vim.g.neovide_cursor_vfx_particle_curl = 1.5

vim.opt.guifont = "SauceCodePro Nerd Font:h10"
vim.g.gui_font_default_size = 8
vim.g.gui_font_size = vim.g.gui_font_default_size
vim.g.gui_font_face = "SauceCodePro Nerd Font"

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

local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "i" }, "<C-=>", function()
	resizeGuiFont(1)
end, opts)
vim.keymap.set({ "n", "i" }, "<C-->", function()
	resizeGuiFont(-1)
end, opts)
