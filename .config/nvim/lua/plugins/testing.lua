---@diagnostic disable:missing-fields
return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-jest",
		"nvim-neotest/neotest-python",
		"nvim-neotest/neotest-plenary",
		"thenbe/neotest-playwright",
	},
	config = function()
		require("neotest").setup({
			-- discovery = {
			-- 	enabled = false,
			-- },
			adapters = {
				require("neotest-plenary"),
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestConfigFile = "jest.config.js",
					jest_test_discovery = true,
					env = { CI = true },
					cwd = function()
						return vim.fn.getcwd()
					end,
				}),
				require("neotest-playwright").adapter({
					options = {
						env = {
							PW_TEST_CONNECT_WS_ENDPOINT = "ws://0.0.0.0:9999",
						},
						persist_project_selection = true,
						enable_dynamic_test_discovery = true,
						is_test_file = function(file_path)
							local result = file_path:find("tests/e2e/.*")
							return result
						end,
					},
				}),
			},
		})
	end,
	keys = {
		{
			"<leader>tt",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run File",
		},
		{
			"<leader>tT",
			function()
				require("neotest").run.run(vim.uv.cwd())
			end,
			desc = "Run All Test Files",
		},
		{
			"<leader>tr",
			function()
				require("neotest").run.run()
			end,
			desc = "Run Nearest",
		},
		{
			"<leader>tl",
			function()
				require("neotest").run.run_last()
			end,
			desc = "Run Last",
		},
		{
			"<leader>ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle Summary",
		},
		{
			"<leader>to",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "Show Output",
		},
		{
			"<leader>tO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Toggle Output Panel",
		},
		{
			"<leader>tS",
			function()
				require("neotest").run.stop()
			end,
			desc = "Stop",
		},
	},
}
