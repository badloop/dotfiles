return {
    "akinsho/bufferline.nvim",
    enabled = true,
    config = function()
        -- 	local b = require("bufferline")
        require("bufferline").setup({
            options = {
                always_show_bufferline = true,
                -- 			buffer_close_icon = "",
                -- 			mode = "buffers",
                -- 			-- indicator = {
                -- 			-- 	style = "none",
                -- 			-- },
                -- 			numbers = "bufnr",
                -- 			show_buffer_icons = true,
                -- 			separator_style = "slant",
            },
            -- 		highlights = {
            -- 			fill = {
            -- 				bg = "#000000",
            -- 			},
            -- 			tab = {
            -- 				bg = "#16161d",
            -- 				fg = "#727169",
            -- 			},
            -- 			buffer_visible = {
            -- 				bg = "#16161d",
            -- 				fg = "#727169",
            -- 			},
            -- 			separator = {
            -- 				fg = "#000000",
            -- 			},
            -- 			separator_selected = {
            -- 				fg = "#000000",
            -- 			},
            -- 			separator_visible = {
            -- 				fg = "#000000",
            -- 			},
            -- 		},
        })
        -- 	require("bufferline.highlights").set_all(require("bufferline.config").update_highlights())
    end,
}
