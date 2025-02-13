return {
	"windwp/nvim-autopairs",
	opts = {
		fast_wrap = {},
		disable_filetype = { "TelescopePrompt", "vim" },
	},
	config = function(_, opts)
		local npairs = require("nvim-autopairs")
		-- local cond = require("nvim-autopairs.conds")

		npairs.setup(opts)

		-- Disable auto complete for backticks in PowerShell
		npairs.get_rules("`")[1].not_filetypes = { "ps1" }

		-- setup cmp for autopairs
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
