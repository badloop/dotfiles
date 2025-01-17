return {
	"numToStr/Comment.nvim",
	opts = {},
	config = function()
		local comment = require("Comment")
		local api = require("Comment.api")

		comment.setup()

		vim.keymap.set("n", "<leader>/", function()
			api.toggle.linewise.current()
		end, {})
		vim.keymap.set("v", "<leader>/", function()
			api.toggle.linewise(vim.fn.visualmode())
		end, {})
	end,
}
