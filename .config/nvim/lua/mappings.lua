-- User Functions
local function map(mode, bind, command, opts)
	local options = { noremap = true }
	if type(mode) ~= "table" then
		mode = { mode }
	end
	for _, v in pairs(mode) do
		if opts then
			options = vim.tbl_extend("force", options, opts)
		end
		vim.api.nvim_set_keymap(v, bind, command, opts)
	end
end

-- Key Maps
-- Lazy
map("n", "<leader>L", "<cmd>lua require('lazy').home()<cr>", {})

-- Core
map("n", "<leader>e", "<cmd>E<cr>", {}) -- netrw
map("n", "<leader>w", "<cmd>w<cr>", {})
map("n", "<leader>q", "<cmd>q<cr>", {})
map("n", "<leader>Q", "<cmd>qall<cr>", {})
map("n", "<leader>c", "<cmd>bdelete<cr>", {})
map("n", "<leader>C", "<cmd>bdelete!<cr>", {})
map("n", "<leader>\\", "<C-w>v", {}) -- Vertical buffer split
map("n", "<leader>-", "<C-w>s", {}) -- Horizontal buffer split

-- Motion
map("n", "<leader>o", "o<esc><cr>", {})
map("n", "<leader>O", "O<esc><cr>", {})
map("n", "<C-h>", ":TmuxNavigateLeft<cr>", {})
map("n", "<C-l>", ":TmuxNavigateRight<cr>", {})
map("n", "<C-j>", ":TmuxNavigateDown<cr>", {})
map("n", "<C-k>", ":TmuxNavigateUp<cr>", {})
map("n", "<A-k>", "<C-y>", {})
map("n", "<A-j>", "<C-e>", {})
map("n", "˚", "<cmd>>m-2<cr>", {}) -- Move current line
map("n", "∆", "<cmd><m+<cr>", {}) -- Move current line/visual block down one
map("n", "<C-d>", "<C-d>zz", {})
map("n", "<C-u>", "<C-u>zz", {})
map("v", "J", ":m '>+1<cr>gv=gv", {})
map("v", "K", ":m '<-2<cr>gv=gv", {})
map("n", "n", "nzzzv", {})
map("n", "N", "Nzzzv", {})
map("x", "<leader>p", '"_dP', {})
map("n", "<leader>y", '"+y', { desc = "Enter yank to system clipboard mode" })
map("v", "<leader>y", '"+y', { desc = "Enter yank to system clipboard mode" })
map("n", "<leader>Y", '"+Y', { desc = "Enter yank to system clipboard mode" })

-- LSP
map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", {}) -- Variable rename
map("n", "<leader>lR", '<cmd>lua require("telescope.builtin").lsp_references()<cr>', {}) -- Variable rename
map("n", "<S-k>", "<cmd>lua vim.lsp.buf.hover()<cr>", {}) -- Variable rename
map("n", "<leader>gD", "<cmd> lua vim.lsp.buf.declaration()<cr>", {})
map("n", "<leader>gd", "<cmd> lua vim.lsp.buf.definition()<cr>", {})
map("n", "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<cr>", {})

-- DAP
map("n", "<leader>db", '<cmd>lua require("dap").toggle_breakpoint()<cr>', {})
map("n", "<leader>dc", '<cmd>lua require("dap").set_breakpoint(vim.fn.input("Condition: "))<cr>', {})
map("n", "<leader>ds", '<cmd>lua require("dap").continue()<cr>', {})
map("n", "<leader>dd", '<cmd>lua require("dapui").toggle()<cr>', {})
map("n", "<leader>de", '<cmd>lua require("dapui").eval()<cr>', {})
map("n", "<leader>dv", '<cmd>lua require("dap").step_over()<cr>', {})
map("n", "<leader>di", '<cmd>lua require("dap").step_into()<cr>', {})
map("n", "<leader>do", '<cmd>lua require("dap").step_out()<cr>', {})
map("n", "<leader>dt", '<cmd>lua require("dap").terminate()<cr>', {})
map("n", "<leader>dr", '<cmd>lua require("dap").repl.toggle()<cr>', {})

-- Comment
map("n", "<leader>/", '<cmd>lua require("Comment.api").toggle.linewise.current()<cr>', {})
map("v", "<leader>/", '<esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<cr>', {})

-- Zen mode
map("n", "<leader>Z", "<cmd>ZenMode<cr>", {})

-- Bufferline
map("n", "<leader>bj", "<cmd>BufferLinePick<cr>", {})
map("n", "<A-]>", "<cmd>BufferLineCycleNext<cr>", {})
map("n", "<A-[>", "<cmd>BufferLineCyclePrev<cr>", {})

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", {})
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", {})
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", {})
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", {})
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", {})
map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", {})

-- Telescope -- git
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", {})

-- Git
map("n", "<leader>gs", "<cmd>Gdiffsplit<cr>", {})
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", {})
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", {})

-- Harpoon
map("n", "<leader>a", '<cmd>lua require("harpoon.mark").add_file()<cr>', {})
map("n", "<leader>he", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', {})
map("n", "<leader>1", '<cmd>lua require("harpoon.ui").nav_file(1)<cr>', {})
map("n", "<leader>2", '<cmd>lua require("harpoon.ui").nav_file(2)<cr>', {})
map("n", "<leader>3", '<cmd>lua require("harpoon.ui").nav_file(3)<cr>', {})
map("n", "<leader>4", '<cmd>lua require("harpoon.ui").nav_file(4)<cr>', {})
