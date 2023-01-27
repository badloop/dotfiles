require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

local install_list = {
	"golangci-lint-langserver",
	"gopls",
	"gofumpt",
	"revive",
	"bash-language-server",
	"lua-language-server",
	"yaml-language-server",
	"black",
	"pylint",
	"prettier",
	"delve",
	"jsonlint",
	"typescript-language-server",
	"pyright",
	"stylua",
	"golangci-lint",
	"goimports-reviser",
	"rust-analyzer",
	"rustfmt",
}

for _, pkg in ipairs(install_list) do
	local p = require("mason-registry").get_package(pkg)
	if not p:is_installed() then
		p:install()
	end
end

require("mason-lspconfig").setup({
	ensure_installed = {
		"pyright",
	},
})
