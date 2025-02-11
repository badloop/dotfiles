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
			"<esc><cmd>lua require('Comment.api').locked('toggle.linewise')(vim.fn.visualmode())<cr>gv",
			mode = { "v" },
			desc = "Comment line",
		},
	},
}
