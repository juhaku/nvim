local telescope = require("telescope")
local telescope_actions = require("telescope.actions")
local telescope_actions_state = require("telescope.actions.state")
local file_browser_actions = telescope.extensions.file_browser.actions

local function telescope_buffer_dir()
	return vim.fn.expand("%:p:h")
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
					["<C-S-w>"] = file_browser_actions.change_cwd,
					["-"] = file_browser_actions.goto_parent_dir,
				},
				["n"] = {
					["s"] = telescope_actions.toggle_selection,
					["<C-cr>"] = telescope_actions.file_tab,
					["t"] = telescope_actions.file_tab,
					["<C-c>"] = telescope_actions.close,
					["q"] = telescope_actions.close,
					["%"] = file_browser_actions.create,
					["W"] = file_browser_actions.change_cwd,
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

local function get_active_buf_for_tab(tab_num)
    local is_valid = vim.api.nvim_tabpage_is_valid(tab_num)

    if is_valid == true then
        local window = vim.api.nvim_tabpage_get_win(tab_num)
        return vim.api.nvim_win_get_buf(window)
    else
        return -1
    end
end

local function get_buf_name(bufnr)
	return vim.api.nvim_buf_get_name(bufnr)
end

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

local function get_tabpages()
    local handles = vim.api.nvim_list_tabpages()

    local tabs = {}
    for _, handle in ipairs(handles) do
        table.insert(tabs, {
            tabnr = handle,
            windows = vim.api.nvim_tabpage_list_wins(handle)
        })
    end

    return tabs
end

local function get_tabs()
    local tabs = get_tabpages()

	local pages = {}
	for _, tabpage in ipairs(tabs) do
		local current_bufnr = get_active_buf_for_tab(tabpage.tabnr)

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

local function make_tab_results(opts, tabpages)
	local results = {}
	if opts.settings and opts.settings.all_buffers == true then
		for _, tabpage in ipairs(tabpages) do
			for _, tabbuffer in ipairs(tabpage.buffers) do
				table.insert(results, {
					tabnr = tabpage.tabnr,
					bufnr = tabbuffer.bufnr,
					bufname = tabbuffer.bufname,
					window = tabbuffer.window,
				})
			end
		end
	else
		for _, tabpage in ipairs(tabpages) do
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
	local tabpages = get_tabs()
	opts = vim.tbl_deep_extend("force", {}, themes.get_dropdown(opts or {}))
	local tabpage_results = make_tab_results(opts, tabpages)
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
					local tab = entry.value.tabnr
					vim.cmd("tabnext " .. tab)

					if entry.value.window ~= nil then
						vim.fn.win_gotoid(entry.value.window)
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
