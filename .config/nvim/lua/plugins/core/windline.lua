local default = {
	filetypes = { "default" },
	active = {},
	in_active = {},
}
return {
	"windwp/windline.nvim",
	enabled = true,
	opts = {
		tabline = {},
		statuslines = {
			default,
		},
	},
	config = function()
		require("wlsample.airline")
	end,
}
