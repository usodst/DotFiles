if vim.g.load_lsp then
	return {
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"mason-org/mason-lspconfig.nvim",
			"mason-org/mason-registry",
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
				lemminx = {},
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

			require("mason-lspconfig").setup({
				automatic_enable = vim.tbl_keys(servers or {}),
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- Installed LSPs are configured and enabled automatically with mason-lspconfig
			-- The loop below is for overriding the default configuration of LSPs with the ones in the servers table
			for server_name, config in pairs(servers) do
				vim.lsp.config(server_name, config)
			end
		end,
	}
else
	return {}
end
