-- go.nvim
require("go").setup()

-- gopls
require("lspconfig").gopls.setup({
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	server_capabilities = {
		declarationProvider = true,
	},
	filetypes = { "go", "gomod" },
	-- on_attach = function(client, _)
	--     vim.pretty_print(client)
	-- end,
})

-- golangci-lint-langserver
local lspconfig = require("lspconfig")
local configs = require("lspconfig/configs")

if not configs.golangcilsp then
	configs.golangcilsp = {
		default_config = {
			cmd = { "golangci-lint-langserver" },
			root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
			init_options = {
				-- command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json",
				command = {
					"golangci-lint",
					"run",
					"--enable-all",
					"--out-format",
					"json",
					"--issues-exit-code=1",
				},
			},
		},
	}
end
lspconfig.golangci_lint_ls.setup({
	filetypes = { "go", "gomod" },
})
