-- User Functions
local function map(mode, bind, command, opts)
    local options = { noremap = true, silent = true }
    if type(mode) ~= "table" then
        mode = { mode }
    end
    for _, v in pairs(mode) do
        if opts then
            options = vim.tbl_extend("force", options, opts)
        end
        vim.keymap.set(v, bind, command, options)
    end
end

-- Lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Open Lazy" })
-- Netrw
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Open Netrw" })

-- Key Maps
map("v", "<", "<dv", {})
map("v", ">", ">dv", {})
map("n", "<leader>f", "<cmd>terminal ~/.local/bin/tmux-sessionizer<cr>", {})
map("n", "<leader>w", "<cmd>w<cr>", {})
map("n", "<leader>q", "<cmd>q<cr>", {})
map("n", "<leader>Q", "<cmd>qall<cr>", {})
map("n", "<leader>c", "<cmd>bdelete<cr>", {})
map("n", "<leader>C", "<cmd>bdelete!<cr>", {})
map("n", "<leader>\\", "<C-w>v", {}) -- Vertical buffer split
map("n", "<leader>-", "<C-w>s", {}) -- Horizontal buffer split
map("n", "<leader>'", "ciw'<ESC>pwi'<ESC>", {})
map("n", '<leader>"', 'ciw"<ESC>pwi"<ESC>', {})
map("n", "<leader>o", "o<esc><cr>", {})
map("n", "<leader>O", "O<esc><cr>", {})
map("n", "<C-h>", ":TmuxNavigateLeft<cr>", {})
map("n", "<C-l>", ":TmuxNavigateRight<cr>", {})
map("n", "<C-j>", ":TmuxNavigateDown<cr>", {})
map("n", "<C-k>", ":TmuxNavigateUp<cr>", {})
map("n", "J", "mzJ`z", {})
map("n", "<A-k>", "kzz", {})
map("n", "<A-j>", "jzz", {})
map("n", "˚", "<cmd>>m-2<cr>", {}) -- Move current line
map("n", "∆", "<cmd><m+<cr>", {}) -- Move current line/visual block down one
map(
    "n",
    "<C-f>",
    "<cmd>!sesh list -tz | fzf-tmux -p 55%,60% --no-sort --border-label 'Tmux Session Manager' --prompt ' '<cr>",
    {}
)

map({ "n", "v" }, "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
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
map("n", "<leader>lr", vim.lsp.buf.rename, {})
-- map("n", "<leader>lR", "<cmd>Telescope lsp_references<cr>", {})
map("n", "<S-k>", function()
    vim.lsp.buf.hover({ border = "rounded" })
end, {})
map("n", "<leader>gD", vim.lsp.buf.declaration, {})
map("n", "<leader>gd", vim.lsp.buf.definition, {})
map("n", "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<cr>", {})

-- Git
map("n", "gh", "<cmd>diffget //2<cr>", {})
map("n", "gl", "<cmd>diffget //3<cr>", {})
map("n", "gH", "<cmd>%diffget //2<cr>", {})
map("n", "gL", "<cmd>%diffget //3<cr>", {})

-- FZF Lua
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", {})
map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", {})
-- map("n", "<leader>fa", "<cmd>Telescope find_files hidden=true<cr>", {})

-- Bufferline
map("n", "<leader>bj", "<cmd>BufferLinePick<cr>", {})

-- Blink
map("i", "<C-E>", ":Blink.accept()<cr>", {})

-- OpenCode
map({ "n", "v", "t" }, "<leader>ot", function()
    require("opencode").toggle()
end, {})
map({ "n", "v", "t" }, "<leader>oa", function()
    require("opencode").ask("@file ")
end, {})

-- GitSigns
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Git Preview Hunk" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Git Reset Hunk" })
