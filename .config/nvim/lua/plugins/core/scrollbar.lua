return {
	"petertriho/nvim-scrollbar",
	enabled = true,
	config = function()
		require("scrollbar").setup()
		require("scrollbar.handlers.gitsigns").setup()
	end,
}
