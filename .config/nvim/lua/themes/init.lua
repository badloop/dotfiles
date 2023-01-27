local M = {}
function M.load(use)
	use("folke/tokyonight.nvim")
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("EdenEast/nightfox.nvim")
	use("bluz71/vim-moonfly-colors")
	use("morhetz/gruvbox")
	use("rebelot/kanagawa.nvim")
end

function M.set_theme()
	vim.cmd("color kanagawa")
	vim.cmd("hi WinSeparator guifg=#5ec8d8")
end

return M
