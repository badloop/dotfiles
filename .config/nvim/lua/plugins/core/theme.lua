return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {}
    },
    {
        "artanikin/vim-synthwave84",
        lazy = false,
    },
    {
        "challenger-deep-theme/vim",
        name = "challenger-deep",
        lazy = false,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000, -- make sure to load this before all the other start plugins
        opts = {
            integrations = {
                mason = true,
                treesitter = true,
                treesitter_context = true,
            },
        },
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme catppuccin]])
            -- vim.cmd([[colorscheme tokyonight-night]])
        end,
    },
}
