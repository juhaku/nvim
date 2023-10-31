local get_branches = function()
	local ret_val = {}
	local branches = vim.fn.systemlist("git branch")

	for _, brach in ipairs(branches) do
		local b = vim.fn.split(brach, " ")
		table.insert(ret_val, b)
	end

	return ret_val
end

local get_remote_branches = function()
	local ret_val = {}
	local branches = vim.fn.systemlist("git branch --remotes")

	for _, brach in ipairs(branches) do
		local b = vim.fn.split(brach, " ")
		table.insert(ret_val, b)
	end

	return ret_val
end

local get_current_branch = function()
	for _, branch in ipairs(get_branches()) do
		if #branch == 2 then
			return branch[2]
		end
	end
end

local get_origin = function()
	local remotes = vim.fn.systemlist("git remote -v")
	for _, remote in ipairs(vim.fn.split(remotes[1], "\t")) do
		return remote
	end
end

local function get_remotes()
	local remotes = vim.fn.systemlist("git ls-remote")

	local retVal = {
		tags = {},
		heads = {},
		pulls = {},
	}
	for _, remote in ipairs(remotes) do
		local ref = vim.fn.split(remote, "\t")
		ref = ref[#ref]

		local _, pos = string.find(ref, "refs/")
		if pos ~= nil then
			ref = string.sub(ref, pos + 1)

			local _, heads = string.find(ref, "heads/")
			local _, tags = string.find(ref, "tags/")
			if string.find(ref, "pull") ~= nil then
				table.insert(retVal.pulls, ref)
			elseif heads ~= nil then
				table.insert(retVal.heads, string.sub(ref, heads + 1))
			elseif tags ~= nil then
				table.insert(retVal.tags, string.sub(ref, tags + 1))
			end
		end
	end

	return retVal
end

local function refs_completion()
	local completion = { "HEAD", "FETCH_HEAD", "ORIG_HEAD" }
	local branches = vim.tbl_filter(function(item)
		if item ~= "*" then
			return true
		end
		return false
	end, vim.tbl_flatten(get_branches()))
	local remotes = vim.tbl_flatten(get_remote_branches())

	vim.list_extend(completion, branches)
	vim.list_extend(completion, remotes)

	return completion
end

local function run_in_slit_terminal(command, autoclose)
	vim.api.nvim_create_autocmd({ "TermClose" }, {
		pattern = { "*git*" },
		callback = function(o)
			vim.api.nvim_del_autocmd(o.id)

			if autoclose ~= nil and autoclose == true and vim.v.event.status == 0 then
				vim.api.nvim_buf_delete(o.buf, {})
			end

			local fugitive = vim.fn.bufnr("fugitive")
			if fugitive ~= -1 then
				vim.api.nvim_buf_call(fugitive, function()
					vim.cmd("G")
				end)
			end
		end,
	})

	local cmd = "botright split | terminal " .. command
	vim.cmd(cmd)
end

-- shorter command git commit
vim.api.nvim_create_user_command("Gc", function(opts)
	-- vim.cmd("G commit " .. opts.args)
	run_in_slit_terminal("git commit " .. opts.args)
end, {
	nargs = "?",
	complete = function()
		return { "--amend", "--fixup=" }
	end,
})

vim.api.nvim_create_user_command("Gcam", function(opts)
	-- vim.cmd("G commit -a -m '" .. opts.args .. "'")
	-- if opts.bang == true then
	-- 	vim.cmd("G push")
	-- end
	local command = "git commit -a -m '" .. opts.args .. "'"
	if opts.bang == true then
		command = command .. " && git push"
	end
	run_in_slit_terminal(command)
end, {
	nargs = "?",
	bang = true,
})

vim.api.nvim_create_user_command("Gcmsg", function(opts)
	-- vim.cmd("G commit -m '" .. opts.args .. "'")
	-- if opts.bang == true then
	-- 	vim.cmd("G push")
	-- end
	local command = "git commit -m '" .. opts.args .. "'"
	if opts.bang == true then
		command = command .. " && git push"
	end
	run_in_slit_terminal(command)
end, {
	nargs = "?",
	bang = true,
})

vim.api.nvim_create_user_command("Gaa", function(_)
	vim.cmd("G add --all")
	-- run_in_slit_terminal("git add --all")
end, {})

-- checkout create brach
vim.api.nvim_create_user_command("Gcb", function(opts)
	vim.cmd("G checkout -b " .. opts.args)
	-- run_in_slit_terminal("git checkout -b " .. opts.args)
end, {
	nargs = 1,
})

vim.api.nvim_create_user_command("Gl", function(opts)
	vim.cmd("G pull " .. opts.args)
	-- run_in_slit_terminal("git pull " .. opts.args)
end, {
	nargs = "?",
	complete = function()
		return { "-r" }
	end,
})

vim.api.nvim_create_user_command("Gf", function(opts)
	vim.cmd("G fetch " .. opts.args)
	-- run_in_slit_terminal("git fetch " .. opts.args)
end, {
	nargs = "*",
	complete = function(_, cmd, _)
		if cmd == "Gf " then
			return { "origin" }
		end

		local completion = { "HEAD" }
		local remotes = get_remotes()
		completion = vim.list_extend(completion, remotes.heads)
		completion = vim.list_extend(completion, remotes.pulls)
		completion = vim.list_extend(completion, remotes.tags)

		return completion
	end,
})

vim.api.nvim_create_user_command("Gp", function(opts)
	local command = "git push "

	if opts.bang == true then
		command = command .. "--force-with-lease "
	end
	command = command .. opts.args

	-- vim.cmd(command)
	run_in_slit_terminal(command)
end, {
	bang = true,
	nargs = "?",
	complete = function(_, cmd, _)
		if cmd == "Gp " or "Gp! " then
			return { "--no-verify" }
		end

		return {}
	end,
})

vim.api.nvim_create_user_command("Gpf", function(opts)
	local command = "git push --force-with-lease " .. opts.args
	-- vim.cmd(command)
	run_in_slit_terminal(command)
end, {
	nargs = "?",
	complete = function(_, cmd, _)
		if cmd == "Gp " then
			return { "--no-verify" }
		end

		return {}
	end,
})

vim.api.nvim_create_user_command("Gpsup", function(opts)
	local origin = get_origin()
	local current_branch = get_current_branch()

	-- vim.cmd("G push --set-upstream " .. origin .. " " .. current_branch .. " " .. opts.args)
	run_in_slit_terminal("git push --set-upstream " .. origin .. " " .. current_branch .. " " .. opts.args)
end, {
	nargs = "?",
	complete = function(_, cmd, _)
		if cmd == "Gpsup " then
			return { "--no-verify" }
		end

		return {}
	end,
})

vim.api.nvim_create_user_command("Gco", function(opts)
	vim.cmd("G checkout " .. opts.args)
	-- run_in_slit_terminal("git checkout " .. opts.args)
end, {
	nargs = "?",
	complete = function()
		return refs_completion()
	end,
})

vim.api.nvim_create_user_command("Grb", function(opts)
	vim.cmd("G rebase -i " .. opts.args)
	-- run_in_slit_terminal("git rebase -i " .. opts.args)
end, {
	nargs = "?",
	complete = function()
		return refs_completion()
	end,
})

vim.api.nvim_create_user_command("Gb", function(opts)
	vim.cmd("G branch " .. opts.args)
	-- run_in_slit_terminal("git branch " .. opts.args)
end, {
	nargs = "*",
	complete = function(_, cmd, _)
		if cmd == "Gb " then
			-- return flags
			return { "-l", "-D" }
		else
			return refs_completion()
		end
	end,
})

vim.api.nvim_create_user_command("Glsr", function()
    vim.cmd("G ls-remote")
    -- run_in_slit_terminal("git ls-remote")
end, {})
