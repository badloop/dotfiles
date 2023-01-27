local M = {}
function M.load(use)
	use("mfussenegger/nvim-dap")
	use("rcarriga/nvim-dap-ui")
	use("theHamsta/nvim-dap-virtual-text")
end

function M.config()
	local dap = require("dap")
	dap.adapters = {}
	dap.configurations = {}
	require("debug-config.adapters")
	require("debug-config.dapui")
	require("debug-config.configurations")
	require("debug-config.dap-virtual-text")
	vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error" })
end

return M
