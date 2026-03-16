local version = "0.12.0"
local jar_name = "lemminx-maven-" .. version .. ".jar"
local jar_dir = vim.fn.stdpath("data") .. "/lemminx-maven"
local jar_path = jar_dir .. "/" .. jar_name
-- https://repo.eclipse.org/content/groups/releases/org/eclipse/lemminx/lemminx-maven/0.12.0/lemminx-maven-0.12.0.jar
local download_url = "https://repo.eclipse.org/content/groups/releases/org/eclipse/lemminx/lemminx-maven/"
	.. version
	.. "/"
	.. jar_name

local function download_jar(force)
	if not force and vim.fn.filereadable(jar_path) == 1 then
		return
	end
	vim.fn.mkdir(jar_dir, "p")
	vim.notify("[lemminx-maven] Downloading " .. jar_name .. " …", vim.log.levels.INFO)
	local result = vim.fn.system({ "curl", "-fsSL", "-o", jar_path, download_url })
	if vim.v.shell_error ~= 0 then
		vim.notify("[lemminx-maven] Download failed:\n" .. result, vim.log.levels.ERROR)
	else
		vim.notify("[lemminx-maven] Download complete: " .. jar_path, vim.log.levels.INFO)
	end
end

download_jar(false)

vim.api.nvim_create_user_command("LemminxMavenUpdate", function()
	vim.fn.delete(jar_path)
	download_jar(true)
end, { desc = "Re-download lemminx-maven extension JAR" })

return {
	settings = {
		xml = {
			extension = {
				jars = { jar_path },
			},
		},
		redhat = {
			telemetry = {
				enabled = false,
			},
		},
	},
}
