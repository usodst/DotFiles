return {
	"lewis6991/gitsigns.nvim",
	opts = {
		current_line_blame = true,
		current_line_blame_opts = {
			delay = 500,
		},
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			vim.keymap.set("n", "<leader>gs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Git [S]tage hunk", buffer = bufnr })
			vim.keymap.set("n", "<leader>gr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Git [R]eset hunk", buffer = bufnr })
			vim.keymap.set("n", "<leader>ga", gitsigns.stage_buffer, { desc = "Git St[a]ge Buffer", buffer = bufnr })
			vim.keymap.set("n", "<leader>gd", gitsigns.reset_buffer, { desc = "Git Reset Buffer", buffer = bufnr })
		end,
	},
}
