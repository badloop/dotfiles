local language_servers = {
    { "basedpyright" },
    { "bash-language-server", {
        filetypes = { "bash", "sh", "zsh" },
    } },
    { "beautysh" },
    { "delve" },
    { "eslint_d" },
    { "eslint-lsp" },
    { "gofumpt" },
    { "goimports-reviser" },
    { "golangci-lint" },
    { "golangci-lint-langserver" },
    { "gopls" },
    {
        "html-lsp",
        {
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
    },
    { "js-debug-adapter" },
    { "json-lsp" },
    { "jsonlint" },
    { "kulala-fmt" },
    {
        { "lua_ls", "lua-language-server" },
        {
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
    },
    { "markdownlint" },
    { "marksman" },
    { "prettier" },
    { "pylint" },
    { "revive" },
    { "ruff" },
    { "shellcheck" },
    { "shfmt" },
    { "swiftlint" },
    { "sqlfluff" },
    { "stylua" },
    { "tailwindcss-language-server" },
    { "typescript-language-server" },
    {
        "yaml-language-server",
        {
            settings = {
                yaml = {
                    keyOrdering = false,
                },
            },
        },
    },
}
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "folke/neodev.nvim", ft = "lua", opts = {} },
        { "hrsh7th/cmp-nvim-lsp" },
        { "williamboman/mason-lspconfig.nvim" },
        {
            "williamboman/mason.nvim",
            opts = {
                ensure_installed = (vim.tbl_map(function(server)
                    if type(server[1]) == "table" then
                        return server[1][2]
                    end
                    return server[1]
                end, language_servers)),
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            },
            ---@param opts MasonSettings | {ensure_installed: string[]}
            config = function(_, opts)
                require("mason").setup(opts)
                local mr = require("mason-registry")
                mr:on("package:install:success", function()
                    vim.defer_fn(function()
                        -- trigger FileType event to possibly load this newly installed LSP server
                        require("lazy.core.handler.event").trigger({
                            event = "FileType",
                            buf = vim.api.nvim_get_current_buf(),
                        })
                    end, 100)
                end)

                mr.refresh(function()
                    for _, tool in ipairs(opts.ensure_installed) do
                        local p = mr.get_package(tool)
                        if not p:is_installed() then
                            p:install()
                        end
                    end
                end)
            end,
        },
    },
    opts = {},
    config = function(_, opts)
        local capabilities = {}

        -- Add cmp nvim capabilities
        local cmp = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        vim.tbl_extend("force", capabilities, cmp)

        local ensure_installed = {}
        for _, lsp in pairs(language_servers) do
            -- Check if lsp is table and if so use the second element as the lsp name
            local lsp_name
            local lsp_server
            lsp_name = lsp[1]
            if type(lsp[1]) == "table" then
                lsp_name = lsp[1][1]
                lsp_server = lsp[1][2]
            else
                lsp_name = lsp[1]
                lsp_server = lsp[1]
            end

            ensure_installed[#ensure_installed + 1] = lsp_server
            local config = lsp[2]
            vim.lsp.enable(lsp_name)
            if config then
                vim.lsp.config(lsp_name, config)
            end
        end

        require("mason-lspconfig").setup({
            ensure_installed = opts.ensure_installed,
            automatic_enable = true,
        })
    end,
}
