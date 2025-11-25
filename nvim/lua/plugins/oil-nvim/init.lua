return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			keymaps = {
				["<C-h>"] = false,
				["<C-l>"] = false,
			},
			view_options = {
				show_hidden = true,
			},
		})
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
