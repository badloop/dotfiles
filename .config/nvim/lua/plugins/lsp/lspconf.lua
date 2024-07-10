return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "folke/neodev.nvim", opts = {} },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"mfussenegger/nvim-jdtls",
			"kkoomen/vim-doge",
			{
				"VidocqH/lsp-lens.nvim",
				event = "BufRead",
				opts = {
					enable = false,
					include_declaration = true, -- Reference include declaration
					sections = { -- Enable / Disable specific request
						definition = true,
						references = true,
						implements = true,
					},
				},
				keys = {
					{
						-- LspLensToggle
						"<leader>ul",
						"<cmd>LspLensToggle<CR>",
						desc = "LSP Lens Toggle",
					},
				},
			},
			{
				"j-hui/fidget.nvim",
				opts = {
					logger = {
						level = vim.log.levels.WARN,
					},
				},
			},
		},
		opts = {
			servers = {
				eslint = {},
				tsserver = {},
				jdtls = {},
				pyright = {
					settings = {
						python = {
							venvPath = ".",
							venv = "venv",
							analysis = {
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace",
								diagnosticSeverityOverrides = {
									reportGeneralTypeIssues = "none",
									reportOptionalMemberAccess = "none",
								},
							},
						},
					},
				},
				yamlls = {
					settings = {
						yaml = {
							keyOrdering = false,
						},
					},
				},
				bashls = {
					filetypes = { "bash", "sh", "zsh" },
				},
				marksman = {},
				html = {
					settings = {
						init_options = {
							configurationSection = { "html", "css", "javascript" },
							embeddedLanguages = {
								css = true,
								javascript = true,
							},
							provideFormatter = true,
						},
					},
				},
				lua_ls = {
					single_file_support = true,
					settings = {
						Lua = {
							inlay_hints = true,
							workspace = {
								checkThirdParty = false,
							},
							diagnostics = {
								globals = { "vim" },
								disable = { "missing-fields" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				gopls = {},
				rust_analyzer = {},
			},
			inlay_hints = {
				enabled = true,
			},
			setup = {
				["*"] = function(server, opts) end,
			},
		},
		config = function(_, opts)
			local servers = opts.servers
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local lsp = require("lspconfig")
			local function setup(server)
				local server_opts = servers[server] or {}
				server_opts.capabilities = capabilities
				server_opts.on_attach = function(client, _)
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(true)
					end
				end

				-- print("Setting up " .. server .. " with " .. vim.inspect(server_opts))
				lsp[server].setup(server_opts)
				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				-- require("lspconfig")[server].setup(server_opts)
			end

			local ensure_installed = {}
			for server in pairs(servers) do
				ensure_installed[#ensure_installed + 1] = server
				setup(server)
			end
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
			})
			require("mason-lspconfig").setup_handlers({ setup })
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {
				"bash-language-server",
				"beautysh",
				"black",
				"delve",
				"eslint_d",
				"eslint-lsp",
				"gofumpt",
				"goimports-reviser",
				"golangci-lint",
				"golangci-lint-langserver",
				"gopls",
				"html-lsp",
				"isort",
				"js-debug-adapter",
				"jsonlint",
				"lua-language-server",
				"markdownlint",
				"prettier",
				"pylint",
				"pyright",
				"revive",
				"shellcheck",
				"shfmt",
				"sqlfluff",
				"stylua",
				"tailwindcss-language-server",
				"typescript-language-server",
				"yaml-language-server",
			},
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},
}
