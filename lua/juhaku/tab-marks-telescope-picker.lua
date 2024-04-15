local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
-- local themes = require("telescope.themes")
local telescope_actions = require("telescope.actions")
local telescope_actions_state = require("telescope.actions.state")
local tabs = require("juhaku.tabs-telescope-picker")

local keymap_opts = { noremap = true, silent = true }

local home = os.getenv("HOME")
local config_path = home .. "/.local/share/nvim/"

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
		local tab_results = tabs.get_tab_results()
		for _, tab in ipairs(tab_results) do
			for mindex, mark in ipairs(_marks) do
				if tab.bufname == mark.bufname then
					table.remove(_marks, mindex)
					table.insert(_marks, mindex, { tab = tab })
					break
				end
			end
		end
	end
end

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = { "SessionLoadPost" },
	callback = read_config,
})

---- delete orphaned tab marks
--vim.api.nvim_create_autocmd({ "WinEnter" }, {
--	pattern = { "*" },
--	callback = function()
--		for index, mark in ipairs(_marks) do
--			---@type TabResult
--			local tab = nil
--			for _, t in ipairs(tabs.get_tab_results()) do
--				if mark.tab ~= nil and t.bufname == mark.tab.bufname then
--					tab = t
--					break
--				end
--			end
--			if tab == nil and mark.tab ~= nil then
--				-- delete mark that is not found from currently available tabs
--				table.remove(_marks, index)
--				table.insert(_marks, index, {})
--			elseif tab ~= nil and mark.tab ~= nil then
--				-- mark and tab both exist, update the mark with with the tab
--				-- this is because the bufnr might change
--				table.remove(_marks, index)
--				table.insert(_marks, index, { tab = tab })
--			end
--		end
--	end,
--})

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

---Clear tab all tab marks
---@param prompt_bufnr number telescope prompt buffer number
---@param cwdlen number length of the path of current working directory
local function delete_all_tab_marks(prompt_bufnr, cwdlen)
	for i = 1, 5 do
		table.remove(_marks, i)
		table.insert(_marks, i, {})
	end
	telescope_actions_state
		.get_current_picker(prompt_bufnr)
		:refresh(generate_finder(_marks, cwdlen), { reset_prompt = true })
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

---Select mark by marks `index` number
---@param index integer marks index number
local function select_mark(index)
	local mark = _marks[index]
	if mark.tab ~= nil then
		local _, existing_tab = tabs.find_tab_result_by_name(mark.tab.bufname, tabs.get_tab_results())
		if existing_tab == nil then
			local len = #vim.fn.getcwd()
			local name = string.sub(mark.tab.bufname, len + 1)

			vim.notify("Tab mark: " .. index .. " points to stale tab window ." .. name .. "!", vim.log.levels.WARN)
			return
		end

		vim.cmd("tabnext " .. existing_tab.tabnr)

		if mark.tab.window ~= nil then
			vim.fn.win_gotoid(existing_tab.window)
		end
	else
		vim.notify("Tab mark: " .. index .. " is not set!", vim.log.levels.INFO)
	end
end

local function tab_marks_picker(opts)
	opts = vim.tbl_deep_extend("force", {
		initial_mode = "normal",
	}, tabs.tabs_picker_config, opts or {})
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
					select_mark(entry.index)
				end)

				map("n", "D", function()
					delete_all_tab_marks(prompt_bufnr, cwdlen)
					save_config()
				end)
				map("n", "d", function()
					delete_tab_mark(prompt_bufnr, cwdlen)
					save_config()
				end)
				map("i", "<C-d>", function()
					delete_tab_mark(prompt_bufnr, cwdlen)
					save_config()
				end)
				map("n", "J", function()
					-- down
					move_tab_mark_down(prompt_bufnr, cwdlen)
					save_config()
				end)
				map("n", "K", function()
					-- up
					move_tab_mark_up(prompt_bufnr, cwdlen)
					save_config()
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

		if tab ~= nil and idx ~= nil then
			table.remove(_marks, idx)
			table.insert(_marks, idx, {
				tab = tab,
			})
			save_config()
		end
	end)
end, keymap_opts)

vim.keymap.set("n", "<leader>tm", function()
	tab_marks_picker()
end, keymap_opts)

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
