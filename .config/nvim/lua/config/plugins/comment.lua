return {
	"numToStr/Comment.nvim",
	opts = {},
	keys = {
		{
			"<leader>/",
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			mode = { "n" },
			desc = "Comment line",
		},
		{
			"<leader>/",
			function()
				require("Comment.api").toggle.linewise.current(vim.fn.visualmode())
			end,
			mode = { "v" },
			desc = "Comment line",
		},
	},
}
