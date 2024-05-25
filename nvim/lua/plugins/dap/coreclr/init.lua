local M = {}

M.adapter = {
	type = "executable",
	command = vim.fs.find({ "netcoredbg", "netcoredbg.exe" }, {
		path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg",
		type = "file",
	})[1],
	args = { "--interpreter=vscode" },
}

M.config = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
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
	},
}

return M
