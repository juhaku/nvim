return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		local function get_version()
			local cmd = vim.api.nvim_parse_cmd("version", {})
			local output = vim.api.nvim_cmd(cmd, { output = true })
			local list = vim.split(output, "\n")
			local versions = {}
			for index, value in ipairs(list) do
				if value ~= "" and index < 5 then
					table.insert(versions, value)
				end
			end

			return vim.fn.join(versions, "\n")
		end

		dashboard.section.buttons.val = {
			dashboard.button("e", "  New file", ":ene <BAR> startinsert<CR>"),
			dashboard.button("te", "  Open file browser", ":Telescope file_browser<CR>"),
			dashboard.button("tt", "λ  Terminal", ":terminal<CR>"),
			dashboard.button("os", "⌥  Open session", ":SessionManager load_session<CR>"),
			dashboard.button("ol", "󰦛  Open last session", ":SessionManager load_last_session<CR>"),
			dashboard.button("q", "󰈆  Quit NVIM", ":qa<CR>"),
		}
		dashboard.section.footer.val = get_version()

		alpha.setup(dashboard.config)
	end,
}
