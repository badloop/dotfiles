return {
	"windwp/windline.nvim",
	enabled = true,
	opts = {
		tabline = {},
	},
	config = function()
		require("wlsample.airline")
		local basic = require("windline.components.basic")
		local default = {
			filetypes = { "default" },
			active = {
				basic.git,
			},
			in_active = {},
		}
		return {
			statuslines = {
				default,
			},
		}
	end,
}
