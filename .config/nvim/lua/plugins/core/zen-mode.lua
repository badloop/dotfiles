return {
	"folke/zen-mode.nvim",
	enabled = true,
	config = function()
		require("zen-mode").setup({
			window = {
				width = 160,
				backdrop = 0.5,
			},
		})
	end,
}
