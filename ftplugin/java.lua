local lsp_config = require("plugins.lsp-config")
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local jdtls_path = "/home/juha/.local/share/nvim/mason/packages/jdtls"
local jdtls_launcher = "org.eclipse.equinox.launcher_*.jar"

local home = os.getenv("HOME")

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/.config/jdtls/" .. project_name

local bundles = {
	vim.fn.glob(
		home
			.. "/.config/nvim/lib/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
	),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.config/nvim/lib/vscode-java-test/server/*.jar"), "\n"))

local jdtls = require("jdtls")

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local function get_jdks()
	local jdk_paths = vim.fn.systemlist("fd java /usr/lib/jvm -d 1")
	local jdks = {}

	for _, path in ipairs(jdk_paths) do
		local version = string.gsub(path, "[a-zA-Z/-]*", "")
		if tonumber(version) < 9 and tonumber(version) > 5 then
			version = "1." .. version
		end
		table.insert(jdks, {
			name = "JavaSE-" .. version,
			path = path,
		})
	end

	table.sort(jdks, function(a, b)
		return a.name < b.name
	end)

	return jdks
end

local config = {
	cmd = {
		-- use java 17 or never to run
		"/usr/lib/jvm/java-18-openjdk/bin/java",

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		-- '-Dlog.protocol=true',
		"-Dlog.level=ALL",
		"-Xms4G",
		"-javaagent:" .. home .. "/.config/nvim/lib/lombok.jar",
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

	root_dir = require("jdtls.setup").find_root({ "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }),

	on_attach = function(client, bufnr)
		require("jdtls").setup_dap({ hotcodereplace = "auto" })
		require("jdtls.dap").setup_dap_main_class_configs()
		require("jdtls.setup").add_commands()

		lsp_config.on_attach(client, bufnr)
	end,
	capabilities = lsp_config.capabilities,

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {
			import = {
				saveActions = {
					organizeImports = true,
				},
			},
			maven = {
				downloadSources = true,
			},
			signatureHelp = {
				enabled = true,
			},
			configuration = {
				runtimes = get_jdks(),
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

vim.cmd([[
    command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
    command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
    command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
    command! -buffer JdtJol lua require('jdtls').jol()
    command! -buffer JdtBytecode lua require('jdtls').javap()
    command! -buffer JdtJshell lua require('jdtls').jshell()
]])

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "<C-S-o>", ":lua require('jdtls').organize_imports()<CR>", opts)
keymap.set("n", "<leader>tm", ":lua require('jdtls').test_nearest_method()<CR>", opts)
keymap.set("n", "<leader>tc", ":lua require('jdtls').test_class()<CR>", opts)

-- nnoremap <A-o> <Cmd>lua require'jdtls'.organize_imports()<CR>
-- nnoremap crv <Cmd>lua require('jdtls').extract_variable()<CR>
-- vnoremap crv <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>
-- nnoremap crc <Cmd>lua require('jdtls').extract_constant()<CR>
-- vnoremap crc <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>
-- vnoremap crm <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>

-- -- If using nvim-dap
-- -- This requires java-debug and vscode-java-test bundles, see install steps in this README further below.
-- nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
-- nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>
