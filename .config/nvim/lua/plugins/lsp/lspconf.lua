return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		opts = {
			servers = {
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
					on_attach = function(_, bufnr)
						-- if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
						-- 	vim.diagnostic.disable()
						-- end
					end,
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
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				rust_analyzer = {},
				gopls = {},
			},
			setup = {
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
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
				-- print("Setting up " .. server .. " with " .. vim.inspect(server_opts))
				lsp[server].setup(server_opts)
				-- if opts.setup[server] then
				-- 	if opts.setup[server](server, server_opts) then
				-- 		return
				-- 	end
				-- elseif opts.setup["*"] then
				-- 	if opts.setup["*"](server, server_opts) then
				-- 		return
				-- 	end
				-- end
				-- require("lspconfig")[server].setup(server_opts)
			end

			local mlsp = require("mason-lspconfig")
			local available = mlsp.get_available_servers()
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
				"gofumpt",
				"goimports-reviser",
				"golangci-lint",
				"golangci-lint-langserver",
				"gopls",
				"html-lsp",
				"isort",
				"jsonlint",
				"lua-language-server",
				"markdownlint",
				"prettier",
				"pylint",
				"pyright",
				"revive",
				"rust-analyzer",
				"rustfmt",
				"shellcheck",
				"shfmt",
				"sqlfluff",
				"stylua",
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
