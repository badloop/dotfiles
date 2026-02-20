return {
    "nvim-lualine/lualine.nvim",
    name = "lualine",
    opts = {
            globalstatus = true,
            sections = {
                lualine_b = { { 'branch', icon = { "" } }, 'diff', 'diagnostics' },
                lualine_c = {
                    {
                        "filename",
                        path = 2,
                        file_status = true,
                    },
                },
            }
        }
    }
