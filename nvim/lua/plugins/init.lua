local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"tpope/vim-sleuth",
	{
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
	},
	{
		"windwp/nvim-autopairs",
		opts = {
			fast_wrap = {},
			disable_filetype = { "TelescopePrompt", "vim" },
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)

			-- setup cmp for autopairs
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{ "numToStr/Comment.nvim", opts = {} },
	{
		"shaunsingh/nord.nvim",
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("nord")
		end,
	},
	{
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
				vim.keymap.set(
					"n",
					"<leader>ga",
					gitsigns.stage_buffer,
					{ desc = "Git St[a]ge Buffer", buffer = bufnr }
				)
				vim.keymap.set("n", "<leader>gd", gitsigns.reset_buffer, { desc = "Git Reset Buffer", buffer = bufnr })
			end,
		},
	},
	{
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
	},
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			-- { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following autocommand is used to enable inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			local servers = {
				bashls = {},
				clangd = {},
				cmake = {},
				csharp_ls = {},
				cssls = {},
				docker_compose_language_service = {},
				dockerls = {},
				html = {},
				jedi_language_server = {},
				terraformls = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				powershell_es = {
					bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
					settings = {
						powershell = {
							codeFormatting = {
								alignPropertyValuePairs = true,
								autoCorrectAliases = true,
								ignoreOneLineBlock = true,
								newLineAfterCloseBrace = true,
								newLineAfterOpenBrace = true,
								openBraceOnSameLine = true,
								pipelineIndentationStyle = "IncreaseIndentationForFirstPipeline",
								useConstantStrings = true,
								whitespaceAroundPipe = true,
							},
						},
					},
				},
				azure_pipelines_ls = {
					settings = {
						yaml = {
							schemas = {
								["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
									"*/.Pipeline*/**/*.y*l",
									"*/.Pipeline*/*.y*l",
									"*/.pipeline*/**/*.y*l",
									"*/.pipeline*/*.y*l",
									"/*.azure*",
									"/azure-pipeline*.y*l",
									"Azure-Pipelines/**/*.y*l",
									"Pipelines/**/*.y*l",
								},
							},
						},
					},
				},
				nil_ls = {},
				-- yaml_ls = {
				-- 	settings = {
				-- 		yaml = {
				-- 			schemas = {
				-- 				kubernetes = "*.k8s.yaml",
				-- 			},
				-- 		},
				-- 	},
				-- },
			}

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"beautysh",
				"black",
				"clang-format",
				"csharpier",
				"netcoredbg",
				"prettier",
				"stylua",
				"yamlfmt",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for tsserver)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		lazy = false,
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { "c", "cpp" }
				if vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
					return
				end

				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end,
			formatters_by_ft = {
				cs = { "csharpier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				lua = { "stylua" },
				markdown = { "prettier" },
				xml = { "prettier" },
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
		end,
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			-- require("mini.ai").setup({ n_lines = 500 })
			-- require("mini.surround").setup()
			--
			-- -- Simple and easy statusline.
			-- --  You could remove this setup call if you don't like it,
			-- --  and try some other statusline plugin
			-- local statusline = require("mini.statusline")
			-- -- set use_icons to true if you have a Nerd Font
			-- statusline.setup({ use_icons = vim.g.have_nerd_font })
			--
			-- -- You can configure sections in the statusline by overriding their
			-- -- default behavior. For example, here we set the section for
			-- -- cursor location to LINE:COLUMN
			-- ---@diagnostic disable-next-line: duplicate-set-field
			-- statusline.section_location = function()
			-- 	return "%2l:%-2v"
			-- end
			--
			-- -- ... and there is more!
			-- --  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"c_sharp",
				"cpp",
				"dockerfile",
				"lua",
				"markdown",
				"markdown_inline",
				"powershell",
				"python",
				"regex",
				"terraform",
				"vimdoc",
				"yaml",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		config = function(_, opts)
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

			-- Prefer git instead of curl in order to improve connectivity in some environments
			require("nvim-treesitter.install").prefer_git = true
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)

			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		end,
	},
	{
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
			vendors = {
				provider = "ollama",
				ollama = {
					["local"] = true,
					endpoint = "127.0.0.1:11434/v1",
					model = "starling-lm",
					parse_curl_args = function(opts, code_opts)
						return {
							url = opts.endpoint .. "/chat/completions",
							headers = {
								["Accept"] = "application/json",
								["Content-Type"] = "application/json",
							},
							body = {
								model = opts.model,
								messages = require("avante.providers").copilot.parse_message(code_opts), -- you can make your own message, but this is very advanced
								max_tokens = 2048,
								stream = true,
							},
						}
					end,
					parse_response_data = function(data_stream, event_state, opts)
						require("avante.providers").openai.parse_response(data_stream, event_state, opts)
					end,
				},
			},
		},
	},
	{
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
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	{
		"xiyaowong/transparent.nvim",
	},
	{
		"folke/tokyonight.nvim",
	},
	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup({
				view_options = {
					show_hidden = true,
				},
			})
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
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
