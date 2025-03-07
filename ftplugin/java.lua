local home = os.getenv("HOME")

local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls"
local jdtls_launcher = "org.eclipse.equinox.launcher_*.jar"
local java_location = "/usr/lib/jvm"
local jdtls_libs_dir = home .. "/.local/share/nvim/jdtls-libs"

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/.local/share/nvim/jdtls/" .. project_name

local bundles = {
	vim.fn.glob(
		jdtls_libs_dir .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
	),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(jdtls_libs_dir .. "/vscode-java-test/server/*.jar"), "\n"))

local jdtls = require("jdtls")

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local global = require("global")

local function get_jdks()
	local jdk_paths = {}
	if global.is_mac() then
		local versions =
			vim.fn.systemlist("ls " .. home .. "/.sdkman/candidates/java | awk '{if ($1 != \"current\") { print $1} }'")
		for _, version in ipairs(versions) do
			table.insert(jdk_paths, home .. "/.sdkman/candidates/java/" .. version)
		end
	else
		jdk_paths = vim.fn.systemlist("fd java " .. java_location .. " -d 1")
	end
	local jdks = {}

	for _, path in ipairs(jdk_paths) do
		local version = string.gsub(path, "[a-zA-Z%./-]*", "")
		version = string.sub(version, 1, 2)
		if tonumber(version) < 9 and tonumber(version) > 5 then
			version = "1." .. version
		end
		table.insert(jdks, {
			name = "JavaSE-" .. version,
			version = version,
			path = path,
		})
	end

	table.sort(jdks, function(a, b)
		return a.name < b.name
	end)

	return jdks
end

local function get_runtimes()
	local jdks = get_jdks()
	local last_version = jdks[#jdks].version

	local runtimes = {}
	for _, jdk in ipairs(jdks) do
		local default = false
		if jdk.version == last_version then
			default = true
		end

		table.insert(runtimes, {
			name = jdk.name,
			path = jdk.path,
			default = default,
		})
	end

	return runtimes
end

local function find_latest_java_path()
	local jdks = get_jdks()
	return jdks[#jdks].path
end

local config = {
	cmd = {
		find_latest_java_path() .. "/bin/java",

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		-- '-Dlog.protocol=true',
		"-Dlog.level=ALL",
		"-Xms512m",
		"-Xmx3G",
		"-javaagent:" .. jdtls_libs_dir .. "/lombok.jar",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		"-jar",
		vim.fn.glob(jdtls_path .. "/plugins/" .. jdtls_launcher),

		"-configuration",
		jdtls_path .. "/config_linux",
		"-data",
		workspace_dir,
	},
	root_dir = require("lspconfig").util.root_pattern(
		".git",
		"mvnw",
		"gradlew",
		"pom.xml",
		"build.gradle",
		"build.gradle.kts"
	)(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())),
	on_attach = function(client, bufnr)
		require("juhaku.plugins.lsp").on_attach(client, bufnr)

		---@diagnostic disable-next-line: missing-fields
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		require("jdtls.dap").setup_dap_main_class_configs()

		vim.cmd([[
            command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
            command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
            command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
            command! -buffer JdtJol lua require('jdtls').jol()
            command! -buffer JdtBytecode lua require('jdtls').javap()
            command! -buffer JdtJshell lua require('jdtls').jshell()
        ]])

		local opts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "<leader><leader>o", jdtls.organize_imports, opts)
		-- keymap.set("n", "<leader>dn", ":lua require('jdtls').test_nearest_method()<CR>", opts)
		-- keymap.set("n", "<leader>dc", ":lua require('jdtls').test_class()<CR>", opts)

		vim.api.nvim_create_user_command("JavaOrganizeImports", jdtls.organize_imports, {})
		vim.api.nvim_create_user_command("JavaTestClass", jdtls.test_class, {})
		vim.api.nvim_create_user_command("JavaTestNearest", jdtls.test_nearest_method, {})

		-- nnoremap crv <Cmd>lua require('jdtls').extract_variable()<CR>
		-- vnoremap crv <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>
		-- nnoremap crc <Cmd>lua require('jdtls').extract_constant()<CR>
		-- vnoremap crc <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>
		-- vnoremap crm <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>
	end,
	capabilities = require("juhaku.plugins.cmp").default_capabilities(),
	handlers = require("juhaku.plugins.lsp").handlers,
	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			import = {
				saveActions = {
					organizeImports = true,
				},
				maven = {
					enabled = true,
				},
				gradle = {
					enabled = true,
				},
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all",
				},
			},
			signatureHelp = {
				enabled = true,
			},
			configuration = {
				runtimes = get_runtimes(),
			},
			completion = {
				matchCase = "off",
				maxResults = 999,
			},
		},
	},
	init_options = {
		bundles = bundles,
		extendedClientCapabilities = extendedClientCapabilities,
	},
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
