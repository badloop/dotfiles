return {
	"wojciech-kulik/xcodebuild.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-tree.lua", -- (optional) to manage project files
		"stevearc/oil.nvim", -- (optional) to manage project files
		"nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
	},
	config = function()
		local progress_handle
		require("xcodebuild").setup({
			integrations = {

				pymobiledevice = {
					enabled = true,
				},
			},
			code_coverage = {
				enabled = true,
			},
			logs = {
				notify = function(message, severity)
					local fidget = require("fidget")
					if progress_handle then
						progress_handle.message = message
						if not message:find("Loading") then
							progress_handle:finish()
							progress_handle = nil
							if vim.trim(message) ~= "" then
								fidget.notify(message, severity)
							end
						end
					else
						fidget.notify(message, severity)
					end
				end,
				notify_progress = function(message)
					local progress = require("fidget.progress")

					if progress_handle then
						progress_handle.title = ""
						progress_handle.message = message
					else
						progress_handle = progress.handle.create({
							message = message,
							lsp_client = { name = "xcodebuild.nvim" },
						})
					end
				end,
			},
		})
	end,
	keys = {
		{
			"<leader>X",
			"<cmd>XcodebuildPicker<cr>",
			mode = { "n" },
			desc = "XCode Run",
		},
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
		{
			"<leader>xs",
			"<cmd>XcodebuildSetup<cr>",
			mode = { "n" },
			desc = "XCode Setup",
		},
		{
			"<leader>xt",
			"<cmd>XcodebuildTestExplorerToggle<cr>",
			mode = { "n" },
			desc = "XCode Toggle Test Explorer",
		},
	},
}
