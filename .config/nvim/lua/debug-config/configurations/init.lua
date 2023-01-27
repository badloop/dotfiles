require("debug-config.configurations.python")
require("debug-config.configurations.go")
require("dap.ext.vscode").load_launchjs()

local dap = require("dap")

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

-- Add dlvFlags for go configs
for _, config in pairs(dap.configurations.go) do
	if not config.dlvFlags then
		config.dlvFlags = {
			"--output",
			"__debug_bin_" .. config.name:gsub(" ", "_"),
		}
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
					for word in string.gmatch(line, "[a-zA-Z0-9_]+") do
						table.insert(words, word)
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
