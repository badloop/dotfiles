return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true, line_length = 10000 },
        dashboard = { enabled = true },
        image = { enabled = true },
        indent = { enabled = true, opts = { animate = { enabled = false } } },
        quickfile = { enabled = true },
        scope = { enabled = true },
    },
}
