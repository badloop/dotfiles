return {
    "stevearc/conform.nvim",
    dependencies = {
        "mason.nvim",
    },
    opts = {
        format_on_save = {
            timeout_ms = 3000,
            lsp_format = "fallback",
        },
        format = {
            timeout_ms = 3000,
            async = false, -- not recommended to change
            quiet = false, -- not recommended to change
        },
        formatters_by_ft = {
            fish = { "fish_indent" },
            http = { "kulala" },
            javascript = { "prettierd", "prettier" },
            javascriptreact = { "prettierd", "prettier" },
            lua = { "stylua" },
            python = { "isort", "black" },
            sh = { "shfmt" },
            typescript = { "prettierd", "prettier" },
            typescriptreact = { "prettierd", "prettier" },
            yaml = { "prettierd", "prettier" },
            ["_"] = { "trim_whitespace" },
        },
        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        formatters = {
            injected = { options = { ignore_errors = true } },
            kulala = {
                command = "kulala-fmt",
                args = { "format", "$FILENAME" },
                stdin = false,
            },
        },
    },
}
