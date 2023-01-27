require("lspconfig").pyright.setup({
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	venvPath = ".",
	venv = "venv",
	verboseOutput = true,
	reportGeneralTypeIssues = "none",
})
