-- Diagnostics
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<CR>")

-- Terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Quick Fix
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { desc = "Move down one quickfix entry" })
vim.keymap.set("n", "<M-k>", "<cmd>cprevious<CR>", { desc = "Move up one quickfix entry" })

-- Buffers
vim.keymap.set("n", "<leader>x", "<CMD>bd!<CR>", { desc = "Delete the current buffer" })
vim.keymap.set("n", "<leader>X", function()
	vim.ui.input({ prompt = "Delete buffers matching pattern: " }, function(pattern)
		if pattern == "" then
			return
		end
		local deleted = 0
		local ok, re = pcall(vim.regex, pattern)
		if not ok then
			return
		end
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			local name = vim.api.nvim_buf_get_name(buf)
			if re:match_str(name) then
				vim.api.nvim_buf_delete(buf, { force = true })
				deleted = deleted + 1
			end
		end
		vim.notify(string.format("Deleted %d buffer(s) matching '%s'", deleted, pattern))
	end)
end, { desc = "Delete buffers matching a pattern" })

-- Terminal
vim.keymap.set("n", "<leader>tn", "<cmd>term<CR>", { desc = "Open a terminal " })

-- Source config
vim.keymap.set("n", "<leader>o", ":source $MYVIMRC<CR>", { desc = "Source the Neovim config" })
