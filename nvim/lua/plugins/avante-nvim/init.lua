return {
	"yetone/avante.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below is optional, make sure to setup it properly if you have lazy=true
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
				},
			},
		},
	},
	event = "VeryLazy",
	build = "make", -- This is Optional, only if you want to use tiktoken_core to calculate tokens count
	opts = {
		provider = "ollama",
		ollama = {
			endpoint = "127.0.0.1:11434",
			model = "llama3.1",
		},
	},
}
