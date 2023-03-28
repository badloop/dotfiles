return {
	"jose-elias-alvarez/null-ls.nvim",
	config = function()
		local os = require("os")
		local null_ls = require("null-ls")

		local f = null_ls.builtins.formatting
		local d = null_ls.builtins.diagnostics
		local c = null_ls.builtins.completion

		null_ls.setup({
			-- debug = true,
			sources = {
				-- Formatting
				f.beautysh,
				f.stylua,
				f.black,
				f.fixjson,
				f.goimports_reviser,
				f.gofumpt,
				-- f.sql_formatter.with({
				-- 	args = {
				-- 		"-c",
				-- 		"/users/aaron/.config/nvim/lua/aaron/sql_formatter.json",
				-- 	},
				-- }),
				f.isort,
				f.sqlfluff.with({
					timeout = 20000,
					extra_args = {
						"--config",
						os.getenv("HOME") .. "/.config/nvim/lua/aaron/sqlfluff.cfg",
						"-p",
						"-1",
					},
				}),
				f.prettier.with({
					filetypes = {
						"javascriptreact",
						"typescriptreact",
						"javascript",
						"typescript",
						"css",
					},
					extra_args = {
						"--tab-width",
						"4",
					},
				}),

				-- Diagnostics
				d.pylint.with({
					extra_args = {
						"--init-hook",
						"import sys;import os;sys.path.append(os.getcwd());sys.path.append([r+'/'+d[0] for r, d, f in os.walk('.') if 'site-packages' in d][0])",
					},
					diagnostics = {
						disable = {
							"too-many-argument",
						},
					},
				}),
				d.sqlfluff.with({
					extra_args = {
						"--config",
						os.getenv("HOME") .. "/.config/nvim/lua/aaron/sqlfluff.cfg",
					},
				}),
				d.golangci_lint,
				d.revive,
				d.markdownlint,
				d.zsh,

				-- Completion
				c.spell,
			},
		})
	end,
}
