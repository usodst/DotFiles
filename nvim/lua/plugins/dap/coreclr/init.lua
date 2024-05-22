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
			local conf = require("telescope.config").values
			local GetDllFiles = function()
				local dllFiles = vim.fs.find(function(name, path)
					return name:match(".*dll$") and path:match("bin")
				end, { type = "file", limit = math.huge })
				--
				return require("telescope.pickers")
					.new({}, {
						prompt_title = "Select dll",
						finder = require("telescope.finders").new_table({
							results = dllFiles,
						}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			-- return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
			local program = GetDllFiles()
			return program
		end,
	},
}

return M
