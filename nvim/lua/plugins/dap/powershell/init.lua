local M = {}

local specify_script_args_indicator = "${command:SpecifyScriptArgs}"

local session_file = vim.fn.stdpath("cache") .. "/pses.dap.session.json"
local log_file = vim.fn.stdpath("cache") .. "/pses.dap.log"
local bundled_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"
local editor_path = bundled_path .. "/PowerShellEditorServices/Start-EditorServices.ps1"

local dap_term_buf ---@type integer?
local dap_term_channel ---@type integer?

---@param path string
---@param callback fun(session: table?, err: string?)
local function wait_for_session_file(path, callback)
	local function try(remaining)
		if remaining == 0 then
			callback(nil, ("PSES session file not found: %s"):format(path))
			return
		end
		if vim.fn.filereadable(path) ~= 1 then
			vim.defer_fn(function()
				try(remaining - 1)
			end, 500)
			return
		end

		local f, err = io.open(path, "r")
		if not f then
			callback(nil, err or ("Could not read session file: %s"):format(path))
			return
		end
		local ok, session = pcall(vim.json.decode, f:read("*a"))
		f:close()
		vim.fn.delete(path)

		if not ok then
			callback(nil, "Could not parse PSES session file")
			return
		end
		callback(session)
	end

	try(60)
end

local function ensure_send_key_press_listener()
	local dap = require("dap")
	local key = "powershell.dap.console"

	dap.listeners.after["event_powerShell/sendKeyPress"][key] = function()
		if not dap_term_channel then
			return
		end
		-- Any key works; VS Code sends "p"
		vim.api.nvim_chan_send(dap_term_channel, "p")
	end

	dap.listeners.after.event_terminated[key] = function()
		if dap_term_buf and vim.api.nvim_buf_is_valid(dap_term_buf) then
			vim.api.nvim_buf_delete(dap_term_buf, { force = true })
		end
		dap_term_buf = nil
		dap_term_channel = nil
	end
end

M.config = {
	{
		type = "powershell",
		request = "launch",
		name = "PowerShell Launch File With Arguments",
		script = "${file}",
		args = { specify_script_args_indicator },
		cwd = "${fileDirname}",
	},
}

M.adapter = function(cb, config)
	local args = vim.fn.input("Specify Script Args: ")
	for index, arg in ipairs(config.args or {}) do
		if arg == specify_script_args_indicator then
			config.args[index] = args
		end
	end

	ensure_send_key_press_listener()

	-- Drop a previous headless/non-interactive session file if present
	vim.fn.delete(session_file)

	local cmd = {
		"pwsh",
		"-NoLogo",
		"-NoProfile",
		"-File",
		editor_path,
		"-BundledModulesPath",
		bundled_path,
		"-LogPath",
		log_file,
		"-SessionDetailsPath",
		session_file,
		"-HostName",
		"Neovim",
		"-HostProfileId",
		"Neovim.DAP",
		"-HostVersion",
		"1.0.0",
		"-LogLevel",
		"Normal",
		"-DebugServiceOnly",
		"-EnableConsoleRepl",
	}

	-- Use a dedicated buffer so the script buffer is not converted into a terminal
	dap_term_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_call(dap_term_buf, function()
		dap_term_channel = vim.fn.jobstart(cmd, { term = true })
	end)
	vim.cmd("belowright split")
	vim.api.nvim_set_current_buf(dap_term_buf)
	-- Keep focus on the script being debugged
	vim.cmd("wincmd p")

	wait_for_session_file(session_file, function(session, err)
		if err or not session or not session.debugServicePipeName then
			vim.notify(err or "PSES did not report a debug pipe", vim.log.levels.ERROR)
			cb(nil)
			return
		end

		cb({
			type = "pipe",
			pipe = session.debugServicePipeName,
		})
	end)
end

return M
