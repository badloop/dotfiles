require("telescope").setup({
	defaults = {
		file_ignore_patterns = {
			"^venv/",
			"^.venv/",
			"^.git/",
		},
	},
})
