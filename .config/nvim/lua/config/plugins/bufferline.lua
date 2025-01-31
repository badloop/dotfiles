return {
	"akinsho/bufferline.nvim",
	enabled = true,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			themable = true,
			always_show_bufferline = true,
			show_buffer_icons = true,
			color_icons = true,
			show_close_icon = false,
			highlight = { underline = true, sp = "blue" },
			indicator = { style = "underline" },
			get_element_icon = function(element)
				-- element consists of {filetype: string, path: string, extension: string, directory: string}
				-- This can be used to change how bufferline fetches the icon
				-- for an element e.g. a buffer or a tab.
				-- e.g.
				local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = true })
				return icon, hl
			end,
		},
	},
	keys = {
		{
			"<leader>bj",
			"<cmd>BufferLinePick<cr>",
			mode = { "n" },
			desc = "Choose buffer",
		},
	},
	config = function(_, opts)
		local bl = require("bufferline")
		bl.setup(opts)
	end,
}
