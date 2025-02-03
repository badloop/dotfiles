return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			always_show_bufferline = true,
			show_buffer_icons = true,
			color_icons = true,
			show_close_icon = false,
			highlight = { underline = true, sp = "blue" },
			indicator = { style = "underline" },
			get_element_icon = function(element)
				local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = true })
				return icon, hl
			end,
		},
	},
	keys = {
		{
			"<leader>bj",
			"<cmd>BufferLinePick<cr>",
			desc = "Choose buffer",
		},
	},
	config = function(_, opts)
		require("bufferline").setup(opts)
		-- Fix bufferline when restoring a session
		vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
			callback = function()
				vim.schedule(function()
					pcall(nvim_bufferline)
				end)
			end,
		})
	end,
}
