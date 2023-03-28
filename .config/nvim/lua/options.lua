local os = require("os")
local o = vim.o
local g = vim.g
local d = {}

-- vim.cmd("autocmd!")

-- Globals
g.mapleader = " "
g.loaded_perl_provider = 0
g.python3_host_prog = "/usr/bin/python3"
-- g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.netrw_list_style = 3
g.netrw_banner = 0
g.netrw_browse_split = 0
g.netrw_winsize = 25

-- Options
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
o.fileencoding = "utf-8"
o.clipboard = "unnamed"
o.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo/"
o.undofile = true
o.hlsearch = true
o.incsearch = true
o.colorcolumn = "100"
o.wrap = false
o.updatetime = 50
o.scrolloff = 8
o.list = true
o.listchars = o.listchars .. ",space:⋅"
o.listchars = o.listchars .. ",eol:↴"
o.guicursor = ""

-- Diagnostics
d.source = true
d.severity_sort = true
d.float = {
	source = "always",
	border = "rounded",
}
vim.diagnostic.config(d)

-- Undercurl
vim.cmd([[let &t_Cs = '\e[4:3m']])
vim.cmd([[let &t_Ce = '\e[4:0m']])

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- Format on save
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format({timeout_ms=10000})]])

-- Vertical Help
vim.cmd([[autocmd! FileType help :wincmd L | :vert resize 90]])
