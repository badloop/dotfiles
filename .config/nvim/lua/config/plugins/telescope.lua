return {
	"nvim-telescope/telescope.nvim",
	enabled = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
		"Myzel394/jsonfly.nvim",
	},
	keys = {
		{
			"<leader>fb",
			"<cmd>Telescope git_branches<cr>",
			mode = { "n" },
			desc = "Find and switch Git branches",
		},
		{
			"<leader>fd",
			"<cmd>Telescope diagnostics<cr>",
			mode = { "n" },
			desc = "Show workspace diagnostics",
		},
		{
			"<leader>fa",
			"<cmd>Telescope find_files hidden=true<cr>",
			mode = { "n" },
			desc = "Find files including hidden ones",
		},
		{
			"<leader>ff",
			"<cmd>Telescope find_files<cr>",
			mode = { "n" },
			desc = "Find files",
		},
		{
			"<leader>fg",
			'<cmd> lua require("aaron.telescope-multi")()<cr>',
			mode = { "n" },
			desc = "Run custom Telescope multi-selection",
		},
		{
			"<leader>fh",
			"<cmd>Telescope help_tags<cr>",
			mode = { "n" },
			desc = "Search help tags",
		},
		{
			"<leader>fk",
			"<cmd>Telescope keymaps<cr>",
			mode = { "n" },
			desc = "Show keymaps",
		},
		{
			"<leader>fr",
			"<cmd>Telescope lsp_references<cr>",
			mode = { "n" },
			desc = "Find LSP references",
		},
		{
			"<leader>ft",
			"<cmd>TodoTelescope<cr>",
			mode = { "n" },
			desc = "Show TODOs in the project",
		},
		{
			"<leader>fu",
			"<cmd>Telescope undo<cr>",
			mode = { "n" },
			desc = "Show undo history",
		},
		{
			"<leader>fj",
			"<cmd>Telescope jsonfly<cr>",
			desc = "Open json(fly)",
			ft = { "json", "xml", "yaml" },
			mode = "n",
		},
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
					"^bak/",
				},
			},
			pickers = {
				find_files = {
					theme = "ivy",
				},
			},
		})
		t.load_extension("live_grep_args")
		-- Telescope
	end,
}
