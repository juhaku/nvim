-- shorter command git commit
vim.api.nvim_create_user_command("Gc", function(_)
	vim.cmd("G commit")
end, {})

vim.api.nvim_create_user_command("Gcam", function(opts)
	print(vim.inspect(opts))
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
	bang = true,
	nargs = "*",
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

vim.api.nvim_create_user_command("Gl", function(_)
	vim.cmd("G pull")
end, {})

vim.api.nvim_create_user_command("Gp", function(_)
	vim.cmd("G push")
end, {})

vim.api.nvim_create_user_command("Gpsup", function(_)
	vim.cmd("G push --set-upstream")
end, {})
