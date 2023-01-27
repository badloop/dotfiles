local M = {}
function M.load(use)
	use("lewis6991/impatient.nvim")
	use("nvim-tree/nvim-web-devicons")
	use("nvim-lualine/lualine.nvim")
	use("nvim-treesitter/nvim-treesitter")
	use("nvim-treesitter/playground")
	use("L3MON4D3/LuaSnip")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-nvim-lsp")
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = {
			{ "nvim-lua/plenary.nvim" },
		},
	})
	use("akinsho/bufferline.nvim")
	use("tpope/vim-fugitive")
	use("folke/zen-mode.nvim")
	use("lewis6991/gitsigns.nvim")
	use("numToStr/Comment.nvim")
	use("windwp/nvim-autopairs")
	use("petertriho/nvim-scrollbar")
	use("theprimeagen/harpoon")
	use("ray-x/lsp_signature.nvim")
	use("simrat39/symbols-outline.nvim")
	use("folke/todo-comments.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("norcalli/nvim-colorizer.lua")
	use("onsails/lspkind.nvim")
	use("tpope/vim-dadbod")
	use("christoomey/vim-tmux-navigator")
	use("kristijanhusak/vim-dadbod-ui")
	-- use("glepnir/dashboard-nvim")
end

function M.config()
	require("impatient").enable_profile()
	require("core.treesitter")
	require("core.telescope")
	require("core.lualine")
	require("core.completion")
	require("core.bufferline")
	require("core.fugitive")
	require("core.zen-mode")
	require("core.gitsigns")
	require("core.snip")
	require("core.autopairs")
	require("core.scrollbar")
	require("core.harpoon")
	require("core.signatures")
	require("core.symbols")
	require("core.todo")
	require("core.indent-blankline")
	require("core.colorize")
	-- require("core.dash")
end

return M
