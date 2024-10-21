return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		vim.keymap.set("n", "<C-h>m", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)
		vim.keymap.set("n", "<C-h>a", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<C-h>n", function()
			harpoon:list():next()
		end)
		vim.keymap.set("n", "<C-h>p", function()
			harpoon:list():prev()
		end)
	end,
}
