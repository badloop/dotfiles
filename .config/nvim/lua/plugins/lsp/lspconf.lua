return {
	"neovim/nvim-lspconfig",
	config = function()
		return {
			servers = {
				pyright = {
					venvPath = ".",
					venv = "venv",
					verboseOutput = true,
					reportGeneralTypeIssues = "none",
				},
				yamlls = {},
				bashls = {},
				marksman = {},
				html = {
					{
						init_options = {
							configurationSection = { "html", "css", "javascript" },
							embeddedLanguages = {
								css = true,
								javascript = true,
							},
							provideFormatter = true,
						},
					},
				},
				sumneko_lua = {
					single_file_support = true,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				gopls = {
					server_capabilities = {
						declarationProvider = true,
					},
					filetypes = { "go", "gomod" },
				},
			},
		}
	end,
}
