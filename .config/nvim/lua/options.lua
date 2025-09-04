local os = require("os")
local o = vim.o
local g = vim.g
local d = {}

-- Globals
g.mapleader = " "
g.loaded_perl_provider = 0
g.python3_host_prog = "/usr/bin/python3"
-- g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0

-- NETRW
-- g.loaded_netrw = 1
-- g.loaded_netrwPlugin = 1
g.netrw_liststyle = 3
g.netrw_banner = 1
g.netrw_browse_split = 0
-- g.netrw_winsize = 25

-- Options
vim.opt.completeopt = { "menuone", "noselect", "popup" }

o.autoread = true
o.swapfile = false
o.conceallevel = 0
o.termguicolors = true
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.number = true
o.relativenumber = true
o.cursorline = true
o.autoindent = true
o.smartindent = true
o.background = "dark"
o.hidden = true
o.foldmethod = "indent"
o.foldenable = false
o.signcolumn = "yes:1"
o.laststatus = 3
o.encoding = "utf-8"
-- o.fileencoding = "utf-8"
o.clipboard = "unnamedplus"
o.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo/"
o.undofile = true
o.hlsearch = true
o.incsearch = true
o.wrap = false
o.updatetime = 50
o.scrolloff = 8
o.list = true
o.listchars = o.listchars .. ",space:⋅"
o.listchars = o.listchars .. ",eol:↴"
o.guicursor = ""
o.winborder = "rounded"
o.smartcase = true

-- Diagnostics
d.virtual_text = true
d.source = true
d.severity_sort = true
-- d.float = {
--     source = "always",
--     border = "rounded",
--     prefix = function(diagnostic)
--         return vim.diagnostic.severity[diagnostic.severity] .. ": "
--     end,
-- }
vim.diagnostic.config(d)

-- AUTOCMDS
-- Undercurl
vim.cmd([[let &t_Cs = '\e[4:3m']])
vim.cmd([[let &t_Ce = '\e[4:0m']])

-- Vertical Help
vim.cmd([[autocmd! FileType help :wincmd L | :vert resize 90]])
