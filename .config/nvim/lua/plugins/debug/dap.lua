local javascript_langs = {
	"javascript",
	"typescript",
	"javascriptreact",
	"typescriptreact",
}

return {
	"mfussenegger/nvim-dap",
	opts = {
		defaults = {
			fallback = {
				external_terminal = {
					command = "/usr/bin/alacritty",
					args = { "-e" },
				},
			},
		},
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

		-- Breakpoint def
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error" })

		-- Breakpoint def
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error" })

		-- PYTHON
		dap.adapters.python = {
			type = "executable",
			command = os.getenv("HOME") .. "/.pyenv/versions/debugpy/bin/python",
			args = { "-m", "debugpy.adapter" },
		}

		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Debug Current File",
				program = "${file}",
				pythonPath = function()
					local venv = os.getenv("VIRTUAL_ENV")
					if venv then
						return venv .. "/bin/python"
					else
						return "/usr/bin/python"
					end
				end,
			},
			{
				type = "python",
				request = "attach",
				name = "Attach to remote process...",
				connect = {
					host = function()
						return vim.fn.input("Host: ")
					end,
					port = function()
						return vim.fn.input("Port: ")
					end,
				},
				mode = "remote",
				pythonPath = function()
					local venv = os.getenv("VIRTUAL_ENV")
					if venv then
						return venv .. "/bin/python"
					else
						return "/usr/bin/python"
					end
				end,
			},
		}

		-- Add pythonPath to user defined configurations
		for _, config in pairs(dap.configurations.python) do
			if not config.pythonPath then
				config.pythonPath = function()
					local venv = os.getenv("VIRTUAL_ENV")
					if venv then
						return venv .. "/bin/python"
					else
						return "/usr/bin/python"
					end
				end
			end
		end

		-- Placeholder expansion for launch directives
		local placeholders = {
			["${file}"] = function(_)
				return vim.fn.expand("%:p")
			end,
			["${fileBasename}"] = function(_)
				return vim.fn.expand("%:t")
			end,
			["${fileBasenameNoExtension}"] = function(_)
				return vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r")
			end,
			["${fileDirname}"] = function(_)
				return vim.fn.expand("%:p:h")
			end,
			["${fileExtname}"] = function(_)
				return vim.fn.expand("%:e")
			end,
			["${relativeFile}"] = function(_)
				return vim.fn.expand("%:.")
			end,
			["${relativeFileDirname}"] = function(_)
				return vim.fn.fnamemodify(vim.fn.expand("%:.:h"), ":r")
			end,
			["${workspaceFolder}"] = function(_)
				return vim.fn.getcwd()
			end,
			["${workspaceFolderBasename}"] = function(_)
				return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
			end,
			["${env:([%w_]+)}"] = function(match)
				return os.getenv(match) or ""
			end,
		}
		for type, _ in pairs(dap.configurations) do
			for _, config in pairs(dap.configurations[type]) do
				if config.envFile then
					local filePath = config.envFile
					for key, fn in pairs(placeholders) do
						filePath = filePath:gsub(key, fn)
					end

					-- Verify file exists
					local f = io.open(filePath, "r")
					if f ~= nil then
						for line in io.lines(filePath) do
							local words = {}
							for word in string.gmatch(line, "[^=]+") do
								table.insert(words, all_trim(word))
							end
							if not config.env then
								config.env = {}
							end
							config.env[words[1]] = words[2]
						end
					end
				end
			end
		end
	end,
}
