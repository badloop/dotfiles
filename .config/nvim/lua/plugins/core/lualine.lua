return {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    event = "VeryLazy",
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            -- set an empty statusline till lualine loads
            vim.o.statusline = " "
        else
            -- hide the statusline on the starter page
            vim.o.laststatus = 0
        end
    end,
    opts = {
        theme = "auto",
        globalstatus = true,
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                {
                    "branch",
                    icon = { "" },
                },
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic", "nvim_lsp" },
                    sections = { "error", "warn", "info", "hint" },
                    diagnostics_color = {
                        -- Same values as the general color option can be used here.
                        error = "DiagnosticError", -- Changes diagnostics' error color.
                        warn = "DiagnosticWarn",   -- Changes diagnostics' warn color.
                        info = "DiagnosticInfo",   -- Changes diagnostics' info color.
                        hint = "DiagnosticHint",   -- Changes diagnostics' hint color.
                    },
                    symbols = { error = " ", warn = " ", info = "󰌶 ", hint = " " },

                    update_in_insert = false, -- Update diagnostics in insert mode.
                    always_visible = false,   -- Show diagnostics even if there are none.
                },
            },
            lualine_c = {
                {
                    "filename",
                    path = 2,
                    file_status = true,
                },
            },
            lualine_x = { "filetype", "encoding", "tabs" },
            lualine_y = { "location" },
            lualine_z = {},
        },
    },
}
