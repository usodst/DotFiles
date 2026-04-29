return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
	},
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"bash",
			"c",
			"c_sharp",
			"cpp",
			"csv",
			"dockerfile",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"powershell",
			"python",
			"regex",
			"terraform",
			"vimdoc",
			"yaml",
		})
	end,
}
