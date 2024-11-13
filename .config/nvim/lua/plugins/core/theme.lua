return {
	{
		"levouh/tint.nvim",
		lazy = false,
		config = function()
			require("tint").setup({
				tint = -60,
				saturation = 0.4,
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
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
			-- vim.cmd([[colorscheme catppuccin]])
			vim.cmd([[colorscheme tokyonight-moon]])
		end,
	},
}
