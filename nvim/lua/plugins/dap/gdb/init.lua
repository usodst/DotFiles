local M = {}

M.adapter = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" }
}

M.config = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
  }
}

return M
