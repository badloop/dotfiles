return {
    "akinsho/bufferline.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    name = "bufferline",
    opts = {
        options = {
            indicator = {
                style = "underline"
            },
            show_buffer_icons = true,
            color_icons = true,
			get_element_icon = function(element)
				local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = true })
				return icon, hl
			end,
        }
    },
    config = function(_, opts)
        require("bufferline").setup(opts)
    end
}
