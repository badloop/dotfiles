return {
	"theprimeagen/harpoon",
	enabled = true,
	opts = {},
	keys = {
		{ "<leader>a", '<cmd>lua require("harpoon.mark").add_file()<cr>', desc = "" },
		{ "<leader>e", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', desc = "" },
		{ "<leader>1", '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', desc = "" },
		{ "<leader>2", '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', desc = "" },
		{ "<leader>3", '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', desc = "" },
		{ "<leader>4", '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', desc = "" },
		{ "<leader>5", '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', desc = "" },
	},
}
