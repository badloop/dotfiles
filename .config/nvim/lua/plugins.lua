local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local bootstrap = ensure_packer()

local packer = require("packer")

packer.startup({
	function(use)
		use("wbthomason/packer.nvim")

		require("core").load(use)
		require("lsp").load(use)
		require("debug-config").load(use)
		require("themes").load(use)
		if bootstrap then
			require("packer").sync()
		else
			require("core").config()
			require("lsp").config()
			require("debug-config").config()
			require("themes").set_theme()
		end
	end,
	config = {
		display = {
			open_fn = require("packer.util").float,
		},
	},
})
return packer
