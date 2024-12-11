return {
	"nvim-telescope/telescope.nvim",
	enabled = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	config = function()
		local t = require("telescope")
		local themes = require("telescope.themes")
		t.setup({
			defaults = {
				file_ignore_patterns = {
					"^venv/",
					"^.venv/",
					"^.git/",
				},
			},
			pickers = {
				find_files = {
					theme = "ivy",
				},
			},
		})
		t.load_extension("live_grep_args")
	end,
}
