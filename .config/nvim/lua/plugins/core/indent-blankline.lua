return {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    opts = {
        show_end_of_line = true,
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = false,
        use_treesitter = true,
    },
    config = function()
        for _, keymap in pairs({
            "zo",
            "zO",
            "zc",
            "zC",
            "za",
            "zA",
            "zv",
            "zx",
            "zX",
            "zm",
            "zM",
            "zr",
            "zR",
        }) do
            vim.api.nvim_set_keymap(
                "n",
                keymap,
                keymap .. "<CMD>IndentBlanklineRefresh<CR>",
                { noremap = true, silent = true }
            )
        end
    end,
}
