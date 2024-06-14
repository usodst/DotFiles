local M = {}

local specify_script_args_indicator = "${command:SpecifyScriptArgs}"

local function getAdapterSettings()
	local sessionFile = os.tmpname() .. "json"
	local logFile = os.tmpname() .. "log"
	local bundledPath = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"
	local editorPath = bundledPath .. "/PowerShellEditorServices/Start-EditorServices.ps1"

	return {
		type = "pipe",
		pipe = "${pipe}",
		executable = {
			command = "pwsh",
			args = {
				"-NoLogo",
				"-NoProfile",
				"-NonInteractive",
				"-OutputFormat",
				"Text",
				"-File",
				editorPath,
				"-BundledModulesPath",
				bundledPath,
				"-LogPath",
				logFile,
				"-SessionDetailsPath",
				sessionFile,
				"-HostName",
				"Neovim",
				"-HostProfileId",
				"Neovim.DAP",
				"-HostVersion",
				"1.0.0",
				"-LogLevel",
				"Normal",
				"-DebugServiceOnly",
				"-DebugServicePipeName",
				"${pipe}",
			},
		},
	}
end

M.config = {
	{
		type = "powershell",
		request = "launch",
		name = "PowerShell Launch File With Arguments",
		script = "${file}",
		args = { specify_script_args_indicator },
		cwd = "${file}",
	},
}

M.adapter = function(cb, config)
	local args = vim.fn.input("Specify Script Args: ")
	for index, arg in ipairs(config.args) do
		if arg == specify_script_args_indicator then
			config.args[index] = args
		end
	end
	cb(getAdapterSettings())
end

return M
