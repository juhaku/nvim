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

-- shorter command git commit
vim.api.nvim_create_user_command("Gc", function(opts)
    vim.cmd("G commit " .. opts.args)
end, {
    nargs = "?",
    complete = function()
        return { "--amend", "--fixup=" }
    end,
})

vim.api.nvim_create_user_command("Gcam", function(opts)
    vim.cmd("G commit -a -m '" .. opts.args .. "'")
    if opts.bang == true then
        vim.cmd("G push")
    end
end, {
    nargs = "?",
    bang = true,
})

vim.api.nvim_create_user_command("Gcmsg", function(opts)
    vim.cmd("G commit -m '" .. opts.args .. "'")
    if opts.bang == true then
        vim.cmd("G push")
    end
end, {
    nargs = "?",
    bang = true,
})

vim.api.nvim_create_user_command("Gaa", function(_)
    vim.cmd("G add --all")
end, {})

-- checkout create brach
vim.api.nvim_create_user_command("Gcb", function(opts)
    vim.cmd("G checkout -b " .. opts.args)
end, {
    nargs = 1,
})

vim.api.nvim_create_user_command("Gl", function(opts)
    vim.cmd("G pull " .. opts.args)
end, {
    nargs = "?",
    complete = function()
        return { "-r" }
    end,
})

vim.api.nvim_create_user_command("Gp", function(opts)
    if opts.bang == true then
        vim.cmd("G push --force-with-lease")
    else
        vim.cmd("G push")
    end
end, {
    bang = true,
})

vim.api.nvim_create_user_command("Gpsup", function(_)
    local origin = get_origin()
    local current_branch = get_current_branch()

    vim.cmd("G push --set-upstream " .. origin .. " " .. current_branch)
end, {})

vim.api.nvim_create_user_command("Gco", function(opts)
    vim.cmd("G checkout " .. opts.args)
end, {
    nargs = "?",
    complete = function()
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
    end,
})
