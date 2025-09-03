-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})

require('options')
require('mappings')
local theme_file = os.getenv("HOME") .. "/.config/themes/current/nvim.lua"
dofile(theme_file)

-- Setup lazy.nvim
-- require("lazy").setup({
--     spec = {
--         { src = "https://github.com/folke/snacks.nvim",              name = "snacks" },
--         { src = "https://github.com/rose-pine/neovim",               name = "rose-pine" },
--         { src = "https://github.com/folke/neodev.nvim",              name = "neodev" },
--         { src = "https://github.com/folke/tokyonight.nvim",          name = "tokyonight" },
--         { src = "https://github.com/ibhagwan/fzf-lua/",              name = "fzf-lua" },
--         { src = "https://github.com/nvim-lualine/lualine.nvim",      name = "lualine" },
--         { src = "https://github.com/akinsho/bufferline.nvim",        name = "bufferline" },
--         { src = "https://github.com/neovim/nvim-lspconfig",          name = "nvim-lspconfig" },
--         { src = "https://github.com/tpope/vim-fugitive",             name = "vim-fugitive" },
--         { src = "https://github.com/echasnovski/mini.icons",         name = "mini.icons" },
--         { src = "https://github.com/christoomey/vim-tmux-navigator", name = "vim-tmux-navigator" },
--         { src = "https://github.com/lewis6991/gitsigns.nvim",        name = "gitsigns" },
--         { src = "https://github.com/windwp/nvim-autopairs",          name = "nvim-autopairs" },
--         { src = "https://github.com/rcarriga/nvim-notify",           name = "notify" },
--         { src = "https://github.com/j-hui/fidget.nvim",              name = "fidget" },
--         { src = "https://github.com/Saghen/blink.cmp",               name = "blink.cmp" },
--         { src = "https://github.com/github/copilot.vim",             name = "copilot.vim" },
--         { src = "https://github.com/NickvanDyke/opencode.nvim",      name = "opencode" },
--         { src = "https://github.com/stevearc/conform.nvim",          name = "conform" },
--         { src = "https://github.com/loctvl842/monokai-pro.nvim",     name = "monokai-pro" },
--     },
--     -- Configure any other settings here. See the documentation for more details.
--     -- colorscheme that will be used when installing plugins.
--     install = { colorscheme = { "habamax" } },
--     -- automatically check for plugin updates
--     checker = { enabled = true },
-- })
--
-- -- vim.pack.add({
-- --     { src = "https://github.com/folke/snacks.nvim",              name = "snacks" },
-- --     { src = "https://github.com/rose-pine/neovim",               name = "rose-pine" },
-- --     { src = "https://github.com/folke/neodev.nvim",              name = "neodev" },
-- --     { src = "https://github.com/folke/tokyonight.nvim",          name = "tokyonight" },
-- --     { src = "https://github.com/ibhagwan/fzf-lua/",              name = "fzf-lua" },
-- --     { src = "https://github.com/nvim-lualine/lualine.nvim",      name = "lualine" },
-- --     { src = "https://github.com/akinsho/bufferline.nvim",        name = "bufferline" },
-- --     { src = "https://github.com/neovim/nvim-lspconfig",          name = "nvim-lspconfig" },
-- --     { src = "https://github.com/tpope/vim-fugitive",             name = "vim-fugitive" },
-- --     { src = "https://github.com/echasnovski/mini.icons",         name = "mini.icons" },
-- --     { src = "https://github.com/christoomey/vim-tmux-navigator", name = "vim-tmux-navigator" },
-- --     { src = "https://github.com/lewis6991/gitsigns.nvim",        name = "gitsigns" },
-- --     { src = "https://github.com/windwp/nvim-autopairs",          name = "nvim-autopairs" },
-- --     { src = "https://github.com/rcarriga/nvim-notify",           name = "notify" },
-- --     { src = "https://github.com/j-hui/fidget.nvim",              name = "fidget" },
-- --     { src = "https://github.com/Saghen/blink.cmp",               name = "blink.cmp" },
-- --     { src = "https://github.com/github/copilot.vim",             name = "copilot.vim" },
-- --     { src = "https://github.com/NickvanDyke/opencode.nvim",      name = "opencode" },
-- --     { src = "https://github.com/stevearc/conform.nvim",          name = "conform" },
-- --     { src = "https://github.com/loctvl842/monokai-pro.nvim",     name = "monokai-pro" },
-- -- })
--
-- -- Theme
-- local theme_file = os.getenv("HOME") .. "/.config/themes/current/nvim.lua"
-- dofile(theme_file)
-- -- Directory where the symlink lives
-- local theme_dir = vim.fn.expand("~/.config/themes/current")
--
-- local uv = vim.loop
-- local watcher = uv.new_fs_event()
--
-- local function reload_theme()
--     vim.schedule(function()
--         if vim.fn.filereadable(theme_file) == 1 then
--             vim.cmd("hi clear")
--             dofile(theme_file)
--             vim.notify("Theme reloaded: " .. theme_file, vim.log.levels.INFO)
--         else
--             vim.notify("Theme file not found: " .. theme_file, vim.log.levels.WARN)
--         end
--     end)
-- end
--
-- -- Watch the *directory* for changes
-- watcher:start(theme_dir, { recursive = false }, function(err, fname, status)
--     if err then
--         vim.notify("Theme watcher error: " .. err, vim.log.levels.ERROR)
--         return
--     end
--     if fname == "nvim.lua" then
--         reload_theme()
--     end
-- end)
--
-- vim.api.nvim_create_autocmd("VimLeavePre", {
--     callback = function()
--         watcher:stop()
--         watcher:close()
--     end,
-- })
--
-- local settings = {
--     ["neovim"]             = { opts = { setup = false } },
--     ["vim-fugitive"]       = { opts = { setup = false } },
--     ["nvim-notify"]        = { name = "notify" },
--     ["vim-tmux-navigator"] = { opts = { setup = false } },
--     ["copilot.vim"]        = { opts = { setup = false } },
--     ["nord"]               = { opts = { setup = false } },
--     ["fzf-lua"]            = {
--         opts = {
--             fzf_opts = {
--                 ['--layout'] = 'default',
--                 ['--exact'] = ''
--             },
--             files = {
--                 cmd = " rg --files -g '!venv/' --color=never --hidden",
--                 cwd_prompt = false
--             }
--         }
--     },
--     ["snacks.nvim"]        = {
--         opts = {
--             terminal = {
--                 enabled = true
--             }
--         }
--     },
--     ["nvim-lspconfig"]     = {
--         opts = {
--             lua_ls = {
--                 settings = {
--                     Lua = {
--                         inlay_hints = true,
--                         workspace = { checkThirdParty = false },
--                         diagnostics = {
--                             globals = { "vim" },
--                             disable = { "missing-fields" },
--                         },
--                         completion = {
--                             callSnippet = "Replace",
--                         }
--                     }
--                 },
--                 capabilities = vim.tbl_deep_extend(
--                     "force",
--                     vim.lsp.protocol.make_client_capabilities(),
--                     { window = { workDoneProgress = true } }
--                 )
--             },
--             ts_ls = {},
--             pyright = {},
--             yamlls = {},
--             bashls = {},
--             gopls = {},
--             rust_analyzer = {}
--         }
--     },
--     conform                = {
--         opts = {
--             format_on_save = {
--                 timeout_ms = 500,
--                 lsp_format = "fallback",
--             },
--             formatters_by_ft = {
--                 lua = { "stylua" },
--                 python = { "black" },
--                 javascriptreact = { "prettier" },
--                 typescriptreact = { "prettier" },
--                 javascript = { "prettier" },
--                 typescript = { "prettier" },
--                 json = { "prettier" },
--                 markdown = { "prettier" },
--                 go = { "gofmt" }
--             }
--         }
--     },
--     ['blink.cmp']          = {
--         opts = {
--             signature = { enabled = true },
--             cmdline = {
--                 enabled = false
--             },
--             completion = {
--                 accept = {
--                     auto_brackets = {
--                         enabled = true,
--                     }
--                 },
--                 documentation = { auto_show = true, auto_show_delay_ms = 200 },
--                 ghost_text = {
--                     enabled = vim.g.ai_cmp
--                 },
--                 menu = {
--                     border = "rounded",
--                     draw = {
--                         treesitter = { 'lsp' },
--                     }
--                 }
--             }
--         }
--     },
--     fidget                 = {
--         opts = {
--             integration = {
--                 ["nvim-tree"] = {
--                     enable = false,
--                 },
--             },
--             notification = {
--                 window = {
--                     normal_hl = "String", -- Base highlight group in the notification window
--                     winblend = 0,         -- Background color opacity in the notification window
--                     border = "rounded",   -- Border around the notification window
--                     zindex = 45,          -- Stacking priority of the notification window
--                     max_width = 0,        -- Maximum width of the notification window
--                     max_height = 0,       -- Maximum height of the notification window
--                     x_padding = 1,        -- Padding from right edge of window boundary
--                     y_padding = 1,        -- Padding from bottom edge of window boundary
--                     align = "bottom",     -- How to align the notification window
--                     relative = "editor",  -- What the notification window position is relative to
--                 },
--             },
--         }
--     },
--     lualine                = {
--         opts = {
--             globalstatus = true,
--             sections = {
--                 lualine_b = { { 'branch', icon = { "" } }, 'diff', 'diagnostics' },
--                 lualine_c = {
--                     {
--                         "filename",
--                         path = 2,
--                         file_status = true,
--                     },
--                 },
--             }
--         }
--     }
-- }
--
-- -- Auto processing of plugins
-- local delList = {}
-- for _, plugin in ipairs(vim.pack.get()) do
--     -- Delete plugins that are not active
--     if not plugin.active then
--         vim.notify("Deleting inactive plugin: " .. plugin.spec.name, vim.log.levels.INFO)
--         table.insert(delList, plugin.spec.name)
--     end
--     if delList and #delList > 0 then
--         vim.pack.del(delList)
--     end
--
--     -- Setup plugins, pulling in settings if defined
--     local p = plugin.spec.name
--     if string.find(p, ".nvim$") then
--         p = string.sub(p, 1, -6) -- Remove the .nvim suffix
--     end
--     local o = {}
--     if settings[p] then
--         if settings[p].opts then
--             o = settings[p].opts
--         end
--         if settings[p].name then
--             p = settings[p].name
--         else
--         end
--     end
--     if p == "nvim-lspconfig" then
--         for name, lsp in pairs(o) do
--             vim.lsp.enable(name)
--             vim.lsp.config(name, lsp or {})
--         end
--     else
--         if o.setup == false then
--             -- print("Skipping setup for plugin: " .. p)
--         else
--             local ok, mod = pcall(require, p)
--             if ok then
--                 -- print("Setting up plugin: " .. p)
--                 mod.setup(o)
--             else
--                 vim.notify(mod, vim.log.levels.WARN)
--             end
--         end
--     end
-- end
--
