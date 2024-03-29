return {
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
		end,
	},
}
