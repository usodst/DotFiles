local M = {}

M.adapter = {
	type = "executable",
	command = "gdb",
	args = { "-i", "dap" },
}

M.config = {
	{
		name = "Launch",
		type = "gdb",
		request = "launch",
		program = function()
			local dap = require("dap")
			local path = vim.fn.input({
				prompt = "Path to executable: ",
				default = vim.fn.getcwd() .. "/",
				completion = "file",
			})
			return (path and path ~= "") and path or dap.ABORT
		end,
		cwd = "${workspaceFolder}",
	},
}

return M
