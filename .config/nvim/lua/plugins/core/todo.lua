return {
    "folke/todo-comments.nvim",
    config = function()
        require("todo-comments").setup({
            keywords = {
                FIX = {
                    icon = " ", -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = " ", color = "info" },
                NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
            },
        })
    end,
}
