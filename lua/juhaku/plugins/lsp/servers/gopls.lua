return {
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			-- use defaults
			-- codelenses = {
			--     gc_details = true,
			--     generate = true,
			--     regenerate_cgo = true,
			--     tidy = true,
			--     upgrade_dependency = true,
			--     vendor = true,
			-- },
			--
			hints = {
				parameterNames = true,
				constantValues = true,
				functionTypeParameters = true,
				assignVariableTypes = true,
				compositeLiteralFields = true,
				rangeVariableTypes = true,
			},
		},
	},
}
