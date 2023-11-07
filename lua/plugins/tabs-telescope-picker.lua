local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local themes = require("telescope.themes")
local telescope_actions = require("telescope.actions")
local telescope_actions_state = require("telescope.actions.state")

local keymap_opts = { noremap = true, silent = true }
local tab_picker_default_settings = { settings = { all_buffers = true } }
local tab_picker_sort_last_active = 0
---@type string[] ignored tab names
local ignored_tabs = { "NvimTree.*" }

---Check whether the tab should be ignored from the results
---@param name string tab buffer name to check against ignored ones
---@param ignored string[] ignored tab names supporting glob pattern
---@return boolean wheter tab should be ignored or not
local function is_not_ignored_tab(name, ignored)
	local is_ignored = false
	for _, ignored_pattern in ipairs(ignored) do
		if name:match(ignored_pattern) ~= nil then
			is_ignored = true
			break
		end
	end
	return is_ignored
end

local M = {}

--- Get active buffer number withing given tab
---@param tab_num number tab number to get active buffer number for
---@return number bufnr active buffer number in tab; or -1 if tab is not valid
M.get_active_buf_for_tab = function(tab_num)
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
M.get_buf_name = function(bufnr)
	return vim.api.nvim_buf_get_name(bufnr)
end

---@class Buffer
---@field bufnr number buffer number
---@field bufname string buffer name
---@field window number window number of the buffer

--- Get buffers withing given windows
---@param windows any[] windows
---@return Buffer[] buffers in given windows
M.get_buffers_for_windows = function(windows)
	windows = windows or {}
	local buffers = {}
	for _, window in ipairs(windows) do
		local bufnr = vim.api.nvim_win_get_buf(window)
		table.insert(buffers, {
			bufnr = bufnr,
			bufname = M.get_buf_name(bufnr),
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
M.get_tabpages = function()
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
M.get_tabs = function()
	local tabs = M.get_tabpages()

	local pages = {}
	for _, tabpage in ipairs(tabs) do
		local current_bufnr = M.get_active_buf_for_tab(tabpage.handle)

		if current_bufnr ~= -1 then
			table.insert(pages, {
				tabnr = tabpage.tabnr,
				current_page = current_bufnr,
				current_page_name = M.get_buf_name(current_bufnr),
				buffers = M.get_buffers_for_windows(tabpage.windows),
			})
		end
	end

	return pages
end

---@class TabResult
---@field tabnr number Current tab index number. This may change between restarts.
---@field bufnr number Current buffer number within the tab. This may change upon restarts.
---@field bufname string buffer name within the tab
---@field window number|nil window number of the tab

--- Make tab results from given `tabs` based on given `opts`
---@param opts table table of configuration options
---@param tabs Tab[] currently available tabs
---@return TabResult[] tab_results Telescope viewable results of the the tabs
M.make_tab_results = function(opts, tabs)
	---@type TabResult[]
	local results = {}

	if opts.settings and opts.settings.all_buffers == true then
		for _, tabpage in ipairs(tabs) do
			for _, tabbuffer in ipairs(tabpage.buffers) do
				if tabbuffer.bufname ~= "" or is_not_ignored_tab(tabbuffer.bufname, ignored_tabs) then
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

---Get `TabResult` list that can be used in tab pickers
---@param opts table|nil of optional configuration options
---@return TabResult[] results containg tab results that can be used in pickers
M.get_tab_results = function(opts)
	local o = vim.tbl_deep_extend("force", {}, opts or tab_picker_default_settings)

	return M.make_tab_results(o, M.get_tabs())
end

---@type TabResult[]
local _results = {}

---Find `TabResult` from `results` by `bufnr` of the tab buffer
---@param bufnr number buffer number of the tab window
---@param results TabResult[] tab results to look for buffer
---@return number|nil index Found tab index or `nil` if `results` does not have suchs buffer
---@return TabResult|nil result Found tab result or `nil` if `results` does not have such buffer
M.find_tab_result_by_bufnr = function(bufnr, results)
	local i, found = nil, nil
	for index, tab in ipairs(results) do
		if tab.bufnr == bufnr then
			i = index
			found = tab
			break
		end
	end

	return i, found
end

local function tab_files_picker(opts)
	opts = vim.tbl_deep_extend("force", {}, themes.get_dropdown(opts or {}))
	if tab_picker_sort_last_active == 0 then
		_results = M.get_tab_results(opts)
	end
	local cwdlen = #vim.fn.getcwd()

	pickers
		.new(opts, {
			prompt_title = "Tabs",
			finder = finders.new_table({
				results = _results,
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
	tab_files_picker(tab_picker_default_settings)
end, keymap_opts)

if tab_picker_sort_last_active == 1 then
	vim.api.nvim_create_autocmd({ "WinEnter" }, {
		pattern = { "*" },
		callback = function(opts)
			local res = M.make_tab_results(tab_picker_default_settings, M.get_tabs())

			for _, result in ipairs(res) do
				local existing_index, existing_tab = M.find_tab_result_by_bufnr(result.bufnr, _results)
				if existing_index ~= nil and existing_tab ~= nil then
					table.remove(_results, existing_index)
					if opts.buf == existing_tab.bufnr then
						table.insert(_results, 1, result)
					else
						table.insert(_results, existing_index, result)
					end
				else
					table.insert(_results, result)
				end
			end
		end,
	})
end

return M
