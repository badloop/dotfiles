local javascript_langs = {
	"javascript",
	"typescript",
	"javascriptreact",
	"typescriptreact",
}

return {
	"mfussenegger/nvim-dap",
	opts = {
		console = "integrateTerminal",
	},

	dependencies = {
		"leoluz/nvim-dap-go",

		{ -- NVIM DAP UI
			"rcarriga/nvim-dap-ui",
			opts = {
				icons = { expanded = "", collapsed = "", current_frame = "" },
				layouts = {
					{
						elements = {
							-- Elements can be strings or table with id and size keys.
							"stacks",
							"watches",
							"breakpoints",
							{ id = "scopes", size = 0.5 },
						},
						size = 40, -- 40 columns
						position = "left",
					},
					{
						elements = {
							"console",
							"repl",
						},
						size = 0.25, -- 25% of total lines
						position = "bottom",
					},
				},
			},
		},
		{ -- MICROSOFT'S JS Debugger
			"microsoft/vscode-js-debug",
			-- After install, build it and rename the dist directory to out
			build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
			version = "1.*",
		},
		{ -- NVIM DAP Adapter for MS JS Debugger
			"mxsdev/nvim-dap-vscode-js",
			opts = {
				debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),
				adapters = {
					"chrome",
					"node",
					"pwa-node",
					"pwa-chrome",
					"pwa-msedge",
					"pwa-extensionHost",
					"node-terminal",
				},
			},
		},
		{
			"theHamsta/nvim-dap-virtual-text",
		},
		{
			"nvim-neotest/nvim-nio",
		},
	},

	config = function()
		if vim.fn.filereadable(".vscode/launch.json") then
			require("dap.ext.vscode").load_launchjs(nil, {
				["pwa-node"] = javascript_langs,
				["node"] = javascript_langs,
				["chrome"] = javascript_langs,
				["pwa-chrome"] = javascript_langs,
			})
		end
		local dap = require("dap")
		local ui = require("dapui")
		dap.listeners.before.attach.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			ui.open()
		end
		-- dap.listeners.before.event_terminated.dapui_config = function()
		-- 	ui.close()
		-- end
		-- dap.listeners.before.event_exited.dapui_config = function()
		-- 	ui.close()
		-- end

		-- Breakpoint def
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error" })
	end,
}
