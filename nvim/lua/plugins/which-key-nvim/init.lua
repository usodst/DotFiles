return {
	"folke/which-key.nvim",
	event = "VimEnter",
	config = function()
		require("which-key").setup()

		-- Document existing key chains
		require("which-key").add({
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>d", group = "[D]ocument" },
			{ "<leader>h", group = "Git [H]unk" },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>w", group = "[W]orkspace" },
		})
		-- visual mode
		require("which-key").add({
			{ "<leader>h", desc = "Git [H]unk", mode = "v" },
		})
	end,
}
