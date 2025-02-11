return {
	"wojciech-kulik/xcodebuild.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-tree.lua", -- (optional) to manage project files
		"stevearc/oil.nvim", -- (optional) to manage project files
		"nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
	},
	keys = {
		{
			"<leader>xr",
			"<cmd>XcodebuildRun<cr>",
			mode = { "n" },
			desc = "XCode Run",
		},
		{
			"<leader>xc",
			"<cmd>XcodebuildCleanBuild<cr>",
			mode = { "n" },
			desc = "XCode Clean Build",
		},
		{
			"<leader>xb",
			"<cmd>XcodebuildBuild<cr>",
			mode = { "n" },
			desc = "XCode Build",
		},
	},
	config = function()
		require("xcodebuild").setup({
			-- put some options here or leave it empty to use default settings
		})
	end,
}
