return {
	"numToStr/Comment.nvim",
	opts = {},
	keys = {
		{
			"<leader>/",
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			mode = { "n", "v" },
			desc = "Comment line",
		},
	},
}
