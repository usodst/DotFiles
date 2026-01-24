local M = {}

M.adapter = {
	type = "server",
	executable = {
		command = "dlv",
		args = { "dap", "-l", "127.0.0.1:${port}" },
	},
	host = "127.0.0.1",
	port = "${port}",
}

M.config = {
	{
		name = "Launch",
		type = "go",
		request = "launch",
		outputMode = "remote",
		program = function()
			local dap = require("dap")
			local path = vim.fn.input({
				prompt = "Path to project: ",
				default = vim.fn.getcwd() .. "/",
				completion = "dir",
			})
			return (path and path ~= "") and path or dap.ABORT
		end,
		args = { "-debug" },
		cwd = "${workspaceFolder}",
	},
}

return M
