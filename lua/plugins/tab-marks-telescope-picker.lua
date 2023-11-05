local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local themes = require("telescope.themes")
local telescope_actions = require("telescope.actions")
local telescope_actions_state = require("telescope.actions.state")
local tabs = require("plugins.tabs-telescope-picker")

local keymap_opts = { noremap = true, silent = true }

local home = os.getenv("HOME")
local config_path = home .. "/.config/nvim/lib/"

---@class TabMark
---@field tab TabResult|nil tab result attached to the index.

---@type TabMark[]
local _marks = {
	{},
	{},
	{},
	{},
	{},
}

---Find `TabMark` from `marks` by `bufnr` of the tab buffer
---@param bufnr number buffer number of the tab window
---@param marks TabMark[] tab results to look for buffer
---@return number|nil index Found tab index or `nil` if `results` does not have suchs buffer
---@return TabResult|nil result Found tab result or `nil` if `results` does not have such buffer
local function find_tab_mark_by_bufnr(bufnr, marks)
	local i, found = nil, nil
	for index, tab in ipairs(marks) do
		if tab.tab ~= nil and tab.tab.bufnr == bufnr then
			i = index
			found = tab
			break
		end
	end

	return i, found
end

---Generate new tab marks finder
---@param marks TabMark[] marks to use in the finder
---@param cwdlen number length of the current working directory
---@return table finder for the tab marks telescope
local function generate_finder(marks, cwdlen)
	local m = {}
	for index, mark in ipairs(marks) do
		table.insert(m, table.pack(index, mark))
	end

	return finders.new_table({
		results = m,
		entry_maker = function(marks_list)
			local i, mark = table.unpack(marks_list)
			if mark.tab ~= nil then
				local name = string.sub(mark.tab.bufname, cwdlen + 1)

				return {
					value = mark,
					display = "#" .. i .. " (" .. mark.tab.tabnr .. ") ." .. name,
					ordinal = mark.tab.bufname,
				}
			else
				return {
					value = "",
					display = "None",
					ordinal = "None",
				}
			end
		end,
	})
end

---Delete tab mark from the tab marks picker and refresh the picker
---@param prompt_bufnr number telescope prompt buffer number
---@param cwdlen number length of the path of current working directory
local function delete_tab_mark(prompt_bufnr, cwdlen)
	local entry = telescope_actions_state.get_selected_entry()
	if entry ~= nil and entry.value ~= "" then
		table.remove(_marks, entry.index)
		table.insert(_marks, entry.index, {})
		telescope_actions_state
			.get_current_picker(prompt_bufnr)
			:refresh(generate_finder(_marks, cwdlen), { reset_prompt = true })
	end
end

---Move tab mark down in the tab marks picker
---@param prompt_bufnr number telescope prompt buffer number
---@param cwdlen number length of the path of current working directory
local function move_tab_mark_down(prompt_bufnr, cwdlen)
	local entry = telescope_actions_state.get_selected_entry()

	local index = entry.index
	local len = #_marks

	if index < len then
		local current = _marks[index]

		table.remove(_marks, index)
		table.insert(_marks, index + 1, current)
		local current_picker = telescope_actions_state.get_current_picker(prompt_bufnr)
		local selection = current_picker:get_selection_row()
		print("selection:" .. tostring(selection))

		current_picker:refresh(generate_finder(_marks, cwdlen), { reset_prompt = true })
		telescope_actions.move_selection_next(prompt_bufnr)
		-- current_picker:set_selection(selection + 1)
	end
end

---Move tab mark up in the tab marks picker
---@param prompt_bufnr number telescope prompt buffer number
---@param cwdlen number length of the path of current working directory
local function move_tab_mark_up(prompt_bufnr, cwdlen)
	local entry = telescope_actions_state.get_selected_entry()

	local index = entry.index

	if index > 1 then
		local previous = _marks[index - 1]

		table.remove(_marks, index - 1)
		table.insert(_marks, index, previous)
		telescope_actions_state
			.get_current_picker(prompt_bufnr)
			:refresh(generate_finder(_marks, cwdlen), { reset_prompt = true })
	end
end

local function tab_marks_picker(opts)
	opts = vim.tbl_deep_extend("force", {
		initial_mode = "normal",
	}, themes.get_dropdown(opts or {}))
	local cwdlen = #vim.fn.getcwd()

	pickers
		.new(opts, {
			prompt_title = "Tab Marks",
			-- selection_strategy = "follow",
			finder = generate_finder(_marks, cwdlen),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map) -- map
				telescope_actions.select_default:replace(function()
					telescope_actions.close(prompt_bufnr)
					local entry = telescope_actions_state.get_selected_entry()
					if entry ~= nil and entry.value ~= "" then
						local tab = entry.value.tab.tabnr
						vim.cmd("tabnext " .. tab)

						if entry.value.tab.window ~= nil then
							vim.fn.win_gotoid(entry.value.tab.window)
						end
					end
				end)

				map("n", "d", function()
					delete_tab_mark(prompt_bufnr, cwdlen)
				end)
				map("i", "<C-d>", function()
					delete_tab_mark(prompt_bufnr, cwdlen)
				end)
				map("n", "J", function()
					-- down
					move_tab_mark_down(prompt_bufnr, cwdlen)
				end)
				map("n", "K", function()
					-- up
					move_tab_mark_up(prompt_bufnr, cwdlen)
				end)

				return true
			end,
		})
		:find()
end

vim.keymap.set("n", "<leader>m", function()
	local bufnr = vim.api.nvim_get_current_buf()

	local _results = tabs.get_tab_results()

	vim.ui.input({ prompt = "Mark tab index # 1-5: " }, function(input)
		local idx = tonumber(input)

		local _, tab = tabs.find_tab_result_by_bufnr(bufnr, _results)
		local _, mark = find_tab_mark_by_bufnr(bufnr, _marks)

		if tab ~= nil and idx ~= nil and mark == nil then
			table.remove(_marks, idx)
			table.insert(_marks, idx, {
				tab = tab,
			})
		end
	end)
end, keymap_opts)

vim.keymap.set("n", "<leader>tm", function()
	tab_marks_picker()
end, keymap_opts)

---Select mark by marks `index` number
---@param index integer marks index number
local function select_mark(index)
	local mark = _marks[index]
	if mark.tab ~= nil then
		local tab = mark.tab.tabnr
		vim.cmd("tabnext " .. tab)

		if mark.tab.window ~= nil then
			vim.fn.win_gotoid(mark.tab.window)
		end
	end
end

vim.keymap.set("n", "<leader>1", function()
	select_mark(1)
end, keymap_opts)
vim.keymap.set("n", "<leader>2", function()
	select_mark(2)
end, keymap_opts)
vim.keymap.set("n", "<leader>3", function()
	select_mark(3)
end, keymap_opts)
vim.keymap.set("n", "<leader>4", function()
	select_mark(4)
end, keymap_opts)
vim.keymap.set("n", "<leader>5", function()
	select_mark(5)
end, keymap_opts)

---Get cwd folder name
---@return string cwd folder name
local function get_cwd_name()
	local working_dir = vim.fn.split(vim.fn.getcwd(), "/")
	return working_dir[#working_dir]
end

local function save_config()
	local cwd = get_cwd_name()
	local json = vim.fn.json_encode(_marks)

	local cmd = "echo '" .. json .. "' > " .. config_path .. "tabmarks." .. cwd .. ".json"

	vim.fn.system(cmd)
end

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
	pattern = { "*" },
	callback = save_config,
})

local function read_config()
	local cwd = get_cwd_name()
	local config_file = config_path .. "tabmarks." .. cwd .. ".json"

	local is_config_file = vim.fn.system("test -f " .. config_file .. " && echo 1")
	if tonumber(is_config_file) == 1 then
		local json_str = vim.fn.system("cat " .. config_file)
		_marks = vim.fn.json_decode(json_str)
	end
end

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = { "SessionLoadPost" },
	callback = read_config,
})
