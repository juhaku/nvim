local telescope = require("telescope")
local telescope_actions = require("telescope.actions")
local telescope_actions_state = require("telescope.actions.state")
local file_browser_actions = telescope.extensions.file_browser.actions

local function telescope_buffer_dir()
	local is_file = vim.fn.system("test -f " .. vim.fn.expand("%") .. " && echo 1")
	if tonumber(is_file) == 1 then
		return vim.fn.expand("%:p:h")
	end

	return vim.fn.getcwd()
end

local function send_to_quickfix(promtbufnr)
	telescope_actions.smart_send_to_qflist(promtbufnr)
	vim.cmd([[botright copen]])
end

telescope.setup({
	defaults = {
		winblend = 20,
		mappings = {
			["n"] = {
				["<C-c>"] = telescope_actions.close,
				["q"] = telescope_actions.close,
				["<C-q>"] = send_to_quickfix,
			},
			["i"] = {
				["<C-c>"] = { "<esc>", type = "command" },
				["<C-q>"] = send_to_quickfix,
			},
		},
	},
	pickers = {
		buffers = {
			mappings = {
				["n"] = {
					["<C-d>"] = telescope_actions.delete_buffer,
				},
				["i"] = {
					["<C-d>"] = telescope_actions.delete_buffer,
				},
			},
		},
	},
	extensions = {
		file_browser = {
			-- hijack_netrw = true,
			initial_mode = "normal",
			previewer = false,
			path = telescope_buffer_dir(),
			cwd_to_path = true,
			respect_gitignore = false,
			hidden = true,
			layout_strategy = "horizontal",
			sorting_strategy = "ascending",
			layout_config = {
				horizontal = {
					mirror = true,
					width = 120,
					height = 40,
					prompt_position = "top",
				},
			},
			mappings = {
				["i"] = {
					["<C-c>"] = { "<esc>", type = "command" },
					["<C-s>"] = telescope_actions.toggle_selection,
					["<A-a>"] = file_browser_actions.create,
					["<C-cr>"] = telescope_actions.file_tab,
					["<C-t>"] = telescope_actions.file_tab,
					-- ["<C-S-w>"] = file_browser_actions.change_cwd,
					["-"] = file_browser_actions.goto_parent_dir,
				},
				["n"] = {
					["m"] = telescope_actions.toggle_selection,
					["<C-cr>"] = telescope_actions.file_tab,
					["t"] = telescope_actions.file_tab,
					["<C-c>"] = telescope_actions.close,
					["q"] = telescope_actions.close,
					["%"] = file_browser_actions.create,
					["cd"] = file_browser_actions.change_cwd,
					-- ["W"] = file_browser_actions.change_cwd,
					["-"] = file_browser_actions.goto_parent_dir,
					-- ["/"] = { "i", type = "command" },
				},
			},
		},
	},
})

telescope.load_extension("file_browser")
telescope.load_extension("fzf")

local keymap_opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>te", function()
	telescope.extensions.file_browser.file_browser({
		path = telescope_buffer_dir(),
	})
end, keymap_opts)

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local themes = require("telescope.themes")

--- Get active buffer number withing given tab
---@param tab_num number tab number to get active buffer number for
---@return number bufnr active buffer number in tab; or -1 if tab is not valid
local function get_active_buf_for_tab(tab_num)
	local is_valid = vim.api.nvim_tabpage_is_valid(tab_num)

	if is_valid == true then
		local window = vim.api.nvim_tabpage_get_win(tab_num)
		return vim.api.nvim_win_get_buf(window)
	else
		return -1
	end
end

--- Get buffer name for given buffer number
---@param bufnr number buffer number
---@return string name name of the buffer
local function get_buf_name(bufnr)
	return vim.api.nvim_buf_get_name(bufnr)
end

---@class Buffer
---@field bufnr number buffer number
---@field bufname string buffer name
---@field window number window number of the buffer

--- Get buffers withing given windows
---@param windows any[] windows
---@return Buffer[] buffers in given windows
local function get_buffers_for_windows(windows)
	windows = windows or {}
	local buffers = {}
	for _, window in ipairs(windows) do
		local bufnr = vim.api.nvim_win_get_buf(window)
		table.insert(buffers, {
			bufnr = bufnr,
			bufname = get_buf_name(bufnr),
			window = window,
		})
	end

	return buffers
end

---@class TabPage
---@field handle number tab page file handle
---@field tabnr number tab index number
---@field windows number[] list of window handle numbers in tab

--- Get list of `TabPage`
---@return TabPage[] tab_pages list of tab tages currently available
local function get_tabpages()
	local handles = vim.api.nvim_list_tabpages()

	local tabs = {}
	for index, handle in ipairs(handles) do
		table.insert(tabs, {
			handle = handle,
			tabnr = index,
			windows = vim.api.nvim_tabpage_list_wins(handle),
		})
	end

	return tabs
end

---@class Tab
---@field tabnr number tab index number
---@field current_page number current buffer number
---@field current_page_name string current buffer name
---@field buffers Buffer[] list of buffers in tab page

--- Get currently available tabs
---@return Tab[] tabs currently available tabs
local function get_tabs()
	local tabs = get_tabpages()

	local pages = {}
	for _, tabpage in ipairs(tabs) do
		local current_bufnr = get_active_buf_for_tab(tabpage.handle)

		if current_bufnr ~= -1 then
			table.insert(pages, {
				tabnr = tabpage.tabnr,
				current_page = current_bufnr,
				current_page_name = get_buf_name(current_bufnr),
				buffers = get_buffers_for_windows(tabpage.windows),
			})
		end
	end

	return pages
end

---@class TabResult
---@field tabnr number tab index number
---@field bufnr number buffer number within the tab
---@field bufname string buffer name within the tab
---@field window number|nil window number of the tab

--- Make tab results from given `tabs` based on given `opts`
---@param opts table table of configuration options
---@param tabs Tab[] currently available tabs
---@return TabResult[] tab_results Telescope viewable results of the the tabs
local function make_tab_results(opts, tabs)
	---@type TabResult[]
	local results = {}

	if opts.settings and opts.settings.all_buffers == true then
		for _, tabpage in ipairs(tabs) do
			for _, tabbuffer in ipairs(tabpage.buffers) do
				if tabbuffer.bufname ~= "" then
					table.insert(results, {
						tabnr = tabpage.tabnr,
						bufnr = tabbuffer.bufnr,
						bufname = tabbuffer.bufname,
						window = tabbuffer.window,
					})
				end
			end
		end
	else
		for _, tabpage in ipairs(tabs) do
			table.insert(results, {
				tabnr = tabpage.tabnr,
				bufnr = tabpage.current_page,
				bufname = tabpage.current_page_name,
			})
		end
	end

	return results
end

local function tab_files_picker(opts)
	local tabs = get_tabs()
	opts = vim.tbl_deep_extend("force", {}, themes.get_dropdown(opts or {}))
	local tabpage_results = make_tab_results(opts, tabs)
	local cwdlen = #vim.fn.getcwd()

	pickers
		.new(opts, {
			prompt_title = "Tabs",
			finder = finders.new_table({
				results = tabpage_results,
				entry_maker = function(tabpage)
					local name = string.sub(tabpage.bufname, cwdlen + 1)

					return {
						value = tabpage,
						display = "(" .. tabpage.tabnr .. ") ." .. name,
						ordinal = tabpage.bufname,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _) -- map
				telescope_actions.select_default:replace(function()
					telescope_actions.close(prompt_bufnr)
					local entry = telescope_actions_state.get_selected_entry()
					if entry ~= nil then
						local tab = entry.value.tabnr
						vim.cmd("tabnext " .. tab)

						if entry.value.window ~= nil then
							vim.fn.win_gotoid(entry.value.window)
						end
					end
				end)
				return true
			end,
		})
		:find()
end

vim.keymap.set("n", "<leader>tp", function()
	tab_files_picker({ settings = { all_buffers = true } })
end, keymap_opts)
