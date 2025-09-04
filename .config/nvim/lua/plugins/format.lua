return {
	"stevearc/conform.nvim",
	opts = {
		formatters = {
			options = { ignore_errors = true },
			stylua = {
				args = {
					"--search-parent-directories",
					"--indent-type",
					"Spaces",
					"--stdin-filepath",
					"$FILENAME",
					"-",
				},
			},
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			json = { "prettier" },
			markdown = { "prettier" },
			go = { "gofmt" },
		},
	},
}
