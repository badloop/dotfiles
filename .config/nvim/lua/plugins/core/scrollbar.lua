return {
	"petertriho/nvim-scrollbar",
	enabled = true,
	config = function()
		local handleColor = require("catppuccin.palettes").get_palette("mocha").surface2
		require("scrollbar").setup({
			handle = {
				color = handleColor,
			},
		})
		require("scrollbar.handlers.gitsigns").setup()
	end,
}
