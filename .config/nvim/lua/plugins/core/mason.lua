return {
	"williamboman/mason.nvim",
	enabled = true,
	opts = {
		ensure_installed = {
			"bash-language-server",
			"beautysh",
			"black",
			"delve",
			"gofumpt",
			"goimports-reviser",
			"golangci-lint",
			"golangci-lint-langserver",
			"gopls",
			"jsonlint",
			"lua-language-server",
			"markdownlint",
			"prettier",
			"pylint",
			"pyright",
			"revive",
			"rust-analyzer",
			"rustfmt",
			"sqlfluff",
			"stylua",
			"typescript-language-server",
			"yaml-language-server",
		},
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
	config = function(_, opts)
		require("mason").setup(opts)
		local mr = require("mason-registry")
		for _, tool in ipairs(opts.ensure_installed) do
			local p = mr.get_package(tool)
			if not p:is_installed() then
				p:install()
			end
		end
	end,
}
