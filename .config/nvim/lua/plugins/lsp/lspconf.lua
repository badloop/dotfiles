return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "folke/neodev.nvim", opts = {} },
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "mfussenegger/nvim-jdtls",
            "Hoffs/omnisharp-extended-lsp.nvim",
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
                            workspace = {
                                checkThirdParty = false,
                            },
                            diagnostics = {
                                globals = { "vim" },
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
                gopls = {},
            },
            setup = {
                -- 	jdtls = function(_, opts)
                -- 		vim.api.nvim_create_autocmd("FileType", {
                -- 			pattern = "java",
                -- 			callback = function()
                -- 				-- vim.lsp.set_log_level("DEBUG")
                --
                -- 				local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
                -- 				local workspace_dir = "/home/aaron/code/work/.workspace/" .. project_name
                -- 				local cmd = {
                -- 					"java",
                -- 					"-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1044",
                -- 					"-javaagent:/home/aaron/.local/share/nvim/mason/packages/jdtls/lombok.jar",
                -- 					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
                -- 					"-Dosgi.bundles.defaultStartLevel=4",
                -- 					"-Declipse.product=org.eclipse.jdt.ls.core.product",
                -- 					"-Dlog.protocol=true",
                -- 					"-Dlog.level=ALL",
                -- 					"-Xmx1g",
                -- 					"--add-modules=ALL-SYSTEM",
                -- 					"--add-opens",
                -- 					"java.base/java.util=ALL-UNNAMED",
                -- 					"--add-opens",
                -- 					"java.base/java.lang=ALL-UNNAMED",
                -- 					"-jar",
                -- 					"/home/aaron/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.500.v20230717-2134.jar",
                -- 					"-configuration",
                -- 					"/home/aaron/.local/share/nvim/mason/packages/jdtls/config_linux",
                -- 					"-data",
                -- 					workspace_dir,
                -- 				}
                --
                -- 				-- This is the default if not provided, you can remove it. Or adjust as needed.
                -- 				-- One dedicated LSP server & client will be started per unique root_dir
                -- 				local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })
                --
                -- 				-- Here you can configure eclipse.jdt.ls specific settings
                -- 				-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                -- 				-- for a list of options
                -- 				local settings = {
                -- 					java = {},
                -- 				}
                --
                -- 				local handlers = {
                -- 					-- ["language/status"] = function(_, result)
                -- 					--     -- print(result)
                -- 					-- end,
                -- 					-- ["$/progress"] = function(_, result, ctx)
                -- 					--     -- disable progress updates.
                -- 					-- end,
                -- 				}
                --
                -- 				local config = {
                -- 					cmd = cmd,
                -- 					root_dir = root_dir,
                -- 					settings = settings,
                -- 					handlers = handlers,
                -- 					capabilities = require("cmp_nvim_lsp").default_capabilities(
                -- 						vim.lsp.protocol.make_client_capabilities()
                -- 					),
                -- 				}
                -- 				require("jdtls").start_or_attach(config)
                -- 			end,
                -- 		})
                -- 		return true
                -- 	end,
                -- 	-- example to setup with typescript.nvim
                -- 	-- tsserver = function(_, opts)
                -- 	--   require("typescript").setup({ server = opts })
                -- 	--   return true
                -- 	-- end,
                -- 	-- Specify * to use this function as a fallback for any server
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
                "eslint_d",
                "eslint-lsp",
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
                "shellcheck",
                "shfmt",
                "sqlfluff",
                "stylua",
                "tailwindcss-language-server",
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
