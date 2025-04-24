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
map("n", "<leader>f", "<cmd>terminal ~/.local/bin/tmux-sessionizer<cr>", {})
map("n", "<leader>w", "<cmd>w<cr>", {})
map("n", "<leader>q", "<cmd>q<cr>", {})
map("n", "<leader>Q", "<cmd>qall<cr>", {})
map("n", "<leader>c", "<cmd>bdelete<cr>", {})
map("n", "<leader>C", "<cmd>bdelete!<cr>", {})
map("n", "<leader>\\", "<C-w>v", {}) -- Vertical buffer split
map("n", "<leader>-", "<C-w>s", {})  -- Horizontal buffer split
map("n", "<leader>'", "ciw'<ESC>p", {})
map("n", "<leader>o", "o<esc><cr>", {})
map("n", "<leader>O", "O<esc><cr>", {})
map("n", "<C-h>", ":TmuxNavigateLeft<cr>", {})
map("n", "<C-l>", ":TmuxNavigateRight<cr>", {})
map("n", "<C-j>", ":TmuxNavigateDown<cr>", {})
map("n", "<C-k>", ":TmuxNavigateUp<cr>", {})
-- map("n", "J", "mzJ`z", {})
map("n", "<M-k>", "kzz", {})
map("n", "<M-j>", "jzz", {})
map("n", "˚", "<cmd>>m-2<cr>", {}) -- Move current line
map("n", "∆", "<cmd><m+<cr>", {}) -- Move current line/visual block down one
map(
    "n",
    "<C-f>",
    "<cmd>!sesh list -tz | fzf-tmux -p 55%,60% --no-sort --border-label 'Tmux Session Manager' --prompt ' '<cr>",
    {}
)
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
map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", {})                          -- Variable rename
map("n", "<leader>lR", '<cmd>lua require("telescope.builtin").lsp_references()<cr>', {}) -- Variable rename
map("n", "<S-k>", "<cmd>lua vim.lsp.buf.hover({border = 'rounded'})<cr>", {})            -- Variable rename
map("n", "<leader>gD", "<cmd> lua vim.lsp.buf.declaration()<cr>", {})
map("n", "<leader>gd", "<cmd> lua vim.lsp.buf.definition()<cr>", {})
map("n", "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<cr>", {})

-- Git
map("n", "gh", "<cmd>diffget //2<cr>", {})
map("n", "gl", "<cmd>diffget //3<cr>", {})
map("n", "gH", "<cmd>%diffget //2<cr>", {})
map("n", "gL", "<cmd>%diffget //3<cr>", {})
