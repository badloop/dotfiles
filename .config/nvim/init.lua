-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("options")
require("mappings")
require("lazy").setup({
	{ import = "plugins.core" },
	{ import = "plugins.lsp" },
	{ import = "plugins.debug" },
	{ import = "plugins.extra" },
	{ import = "plugins.linting" },
	{ import = "plugins.formatting" },
	{ import = "plugins.file_access" },
})
require("aaron")

local signs = { Error = " ", Warn = " ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- vim.cmd.colorscheme("catppuccin")
vim.cmd([[highlight WinSeparator guifg=#9cabca]])
