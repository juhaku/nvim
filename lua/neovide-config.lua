local global = require("global")

-- neovide options
vim.g.neovide_opacity = 0.93
vim.g.neovide_remember_window_size = true
-- vim.g.neovide_floating_blur_amount_x = 5.0
-- vim.g.neovide_floating_blur_amount_y = 5.0
vim.g.neovide_cursor_vfx_mode = "torpedo"
vim.g.neovide_cursor_vfx_particle_density = 3
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_vfx_opacity = 50.0
-- vim.g.neovide_cursor_vfx_particle_lifetime = 1.5
-- vim.g.neovide_cursor_vfx_particle_speed = 12.0
-- railgun only
-- vim.g.neovide_cursor_vfx_particle_phase = 9
-- vim.g.neovide_cursor_vfx_particle_curl = 20

local font = "AdwaitaMono Nerd Font Mono"
if global.is_mac() then
	font = "SauceCodePro Nerd Font"
end
local font_size = 11
vim.opt.guifont = font .. ":h" .. font_size

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<C-=>", function()
	change_scale_factor(1.05)
end)
vim.keymap.set("n", "<C-->", function()
	change_scale_factor(1 / 1.05)
end)
vim.keymap.set("n", "<C-0>", function()
	vim.g.neovide_scale_factor = 1.0
end)

if global.is_mac() then
	vim.g.neovide_opacity = 0.93
	vim.g.neovide_window_blurred = true
	vim.g.neovide_input_macos_option_key_is_meta = "both"
end
