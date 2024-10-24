return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"mfussenegger/nvim-dap",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		dapui.setup()

		-- debuggers
		local gdb = require("plugins.dap.gdb")
		local coreclr = require("plugins.dap.coreclr")
		local powershell = require("plugins.dap.powershell")

		dap.adapters.gdb = gdb.adapter
		dap.adapters.coreclr = coreclr.adapter
		dap.adapters.powershell = powershell.adapter

		dap.configurations.c = gdb.config
		dap.configurations.cpp = gdb.config
		dap.configurations.cs = coreclr.config
		dap.configurations.ps1 = powershell.config
		dap.configurations.psm1 = powershell.config

		-- Key bindings
		vim.keymap.set("n", "<leader>dc", function()
			dap.continue()
		end, { desc = "[D]ap [C]ontinue" })
		vim.keymap.set("n", "<leader>dt", function()
			dap.toggle_breakpoint()
		end, { desc = "[D]ap [T]oggle breakpoint" })
		vim.keymap.set("n", "<leader>dl", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
		end, { desc = "[D]ap [L]og point" })
		vim.keymap.set("n", "<leader>db", function()
			dap.set_breakpoint(vim.fn.input("Condition: "), nil, nil)
		end, { desc = "[D]ap toggle condition [B]reakpoint" })
		vim.keymap.set("n", "<leader>do", function()
			dap.step_over()
		end, { desc = "[D]ap [O]ver" })
		vim.keymap.set("n", "<leader>di", function()
			dap.step_into()
		end, { desc = "[D]ap [I]nto" })
		vim.keymap.set("n", "<leader>du", function()
			dap.step_out()
		end, { desc = "[D]ap o[U]t" })
		vim.keymap.set("n", "<leader>dx", function()
			dapui.close()
		end, { desc = "[D]apUI close" })

		-- open / close ui windows automatically
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		-- dap.listeners.before.event_terminated["dapui_config"] = function()
		-- 	dapui.close()
		-- end
		-- dap.listeners.before.event_exited["dapui_config"] = function()
		-- 	dapui.close()
		-- end
	end,
}
