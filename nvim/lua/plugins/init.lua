local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	require("plugins.avante-nvim"),
	require("plugins.Comment-nvim"),
	require("plugins.conform-nvim"),
	require("plugins.gitsigns-nvim"),
	require("plugins.harpoon"),
	require("plugins.mini-nvim"),
	require("plugins.nord-nvim"),
	require("plugins.nvim-autopairs"),
	require("plugins.nvim-cmp"),
	require("plugins.nvim-dap-ui"),
	require("plugins.nvim-lspconfig"),
	require("plugins.nvim-treesitter"),
	require("plugins.oil-nvim"),
	require("plugins.telescope-nvim"),
	require("plugins.todo-comments-nvim"),
	require("plugins.tokyonight-nvim"),
	require("plugins.transparent-nvim"),
	require("plugins.vim-sleuth"),
	require("plugins.which-key-nvim"),
}, {
	ui = {
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
