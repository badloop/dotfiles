return {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
        preview_config = {
            border = "single",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
    },
    keys = {
        {
            "<leader>gp",
            "<cmd>Gitsigns preview_hunk<cr>",
            mode = { "n" },
            desc = "Git Preview Hunk",
        },
        {

            "<leader>gr",
            "<cmd>Gitsigns reset_hunk<cr>",
            mode = { "n" },
            desc = "Git Reset Hunk",
        },
    },
}
