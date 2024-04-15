return {
	"nvim-lualine/lualine.nvim",
	config = function()
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

		local function cwd()
			local working_dir = vim.fn.split(vim.fn.getcwd(), "/")
			return working_dir[#working_dir]
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
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
				lualine_c = { cwd, "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { cwd, "filename" },
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
			extensions = {},
		})
	end,
}
