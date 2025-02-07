return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = function(_, opts)
		opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types
			or { "terminal", "Trouble", "qf", "Outline", "trouble" }
		table.insert(opts.open_files_do_not_replace_types, "edgy")
	end,
}
