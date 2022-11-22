local navic = require("nvim-navic")

local get_location = function()
    local file_name = vim.fn.expand("%")
    local ret_val = file_name

    if navic.is_available() then
        local path = navic.get_location()
        if path ~= "" then
            ret_val = ret_val .. " > " .. path
        end
    end

    return ret_val
end

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        -- component_separators = { left = '', right = ''},
        -- section_separators = { left = '', right = ''},
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        -- lualine_c = {
        -- 	{ "filename", path = 1 },
        -- },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            { get_location },
        },
        -- lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            { "filename", path = 1 },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    -- tabline = {
    -- 	-- lualine_a = {
    -- 	-- 	{
    -- 	-- 		"tabs",
    -- 	-- 		max_length = vim.o.columns / 3, -- Maximum width of tabs component.
    -- 	-- 		-- Note:
    -- 	-- 		-- It can also be a function that returns
    -- 	-- 		-- the value of `max_length` dynamically.
    -- 	-- 		mode = 1, -- 0: Shows tab_nr
    -- 	-- 		-- 1: Shows tab_name
    -- 	-- 		-- 2: Shows tab_nr + tab_name

    -- 	-- 		-- tabs_color = {
    -- 	-- 		-- 	-- Same values as the general color option can be used here.
    -- 	-- 		-- 	active = "lualine_{section}_normal", -- Color for active tab.
    -- 	-- 		-- 	inactive = "lualine_{section}_inactive", -- Color for inactive tab.
    -- 	-- 		-- },
    -- 	-- 	},
    -- 	-- },
    -- 	-- lualine_a = {
    -- 	-- 	{
    -- 	-- 		"filename",
    -- 	-- 		file_status = true,
    -- 	-- 		newfile_status = true,
    -- 	-- 		path = 1,
    -- 	-- 		shorting_target = 40,
    -- 	-- 		symbols = {
    -- 	-- 			modified = "[+]",
    -- 	-- 			readonly = "[-]",
    -- 	-- 			unnamed = "[No Name]",
    -- 	-- 			newfile = "[New]",
    -- 	-- 		},
    -- 	-- 	},
    -- 	-- },
    -- 	lualine_b = {},
    -- 	lualine_c = {},
    -- 	lualine_x = {},
    -- 	lualine_y = {},
    -- 	-- lualine_z = { "tabs" },
    -- 	-- lualine_z = {},
    -- },
    extensions = {},
})
