return {
	on_attach = function(client, _)
		-- disable eslint formatting
		client.server_capabilities.documentFormattingProvider = false
	end,
}
