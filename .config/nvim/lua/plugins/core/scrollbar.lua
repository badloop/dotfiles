return {
	"petertriho/nvim-scrollbar",
	config = function()
		require("scrollbar").setup({
			excluded_filetypes = {
				"prompt",
				"TelescopePrompt",
				"noice",
				"neo-tree",
				"dashboard",
			},
		})
		require("scrollbar.handlers.gitsigns").setup()
	end,
}
