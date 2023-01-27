local M = {}
function M.load(use)
	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"simrat39/rust-tools.nvim",
	})
	use("folke/neodev.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
end

function M.config()
	require("lsp.main")
	require("lsp.null")
	require("lsp.pyright")
	require("lsp.yamlls")
	require("lsp.bashls")
	require("lsp.html")
	require("lsp.neodev")
	require("lsp.marksman")
	require("lsp.rust")
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return M
