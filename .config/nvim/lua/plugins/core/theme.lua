return {
	{
		"rebelot/kanagawa.nvim",
		opts = {
			undercurl = true,
			commentStyle = { italic = true },
		},
	},
	{
		"EdenEast/nightfox.nvim",
	},
	{
		"folke/tokyonight.nvim",
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
		end,
	},
	{
		"olimorris/onedarkpro.nvim",
	},
	{
		"sainnhe/sonokai",
	},
	{
		"Mofiqul/dracula.nvim",
		opts = {
			italic_comment = true,
		},
	},
	{
		"Shatur/neovim-ayu",
		name = "ayu",
		opts = {
			mirage = true,
		},
	},
}
