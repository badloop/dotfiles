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
                    "^bak/"
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
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope git_branches<cr>", {})
        vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", {})
        vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", {})
        vim.keymap.set("n", "<leader>fg", '<cmd> lua require("aaron.telescope-multi")()<cr>', {})
        vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", {})
        vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", {})
        vim.keymap.set("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", {})
        vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", {})
        vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>", {})
	end,
}
