vim.pack.add({
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/rose-pine/neovim" },
    { src = "https://github.com/vague2k/vague.nvim" },
    { src = "https://github.com/folke/neodev.nvim" },
    { src = "https://github.com/folke/tokyonight.nvim" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/akinsho/bufferline.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/echasnovski/mini.icons" },
    { src = "https://github.com/christoomey/vim-tmux-navigator" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/rcarriga/nvim-notify" },
    { src = "https://github.com/j-hui/fidget.nvim" },
    { src = "https://github.com/Saghen/blink.cmp" },
    { src = "https://github.com/github/copilot.vim" },
    { src = "https://github.com/NickvanDyke/opencode.nvim" },
})

-- Colorscheme
vim.cmd('colorscheme rose-pine')

-- Save on write
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(_)
        local excluded_lsps = { "javascript", "javascriptreact", "typescript", "typescriptreact", "python", "yaml" }
        -- Skip formatting when language server in excluded list
        vim.lsp.buf.format({
            filter = function(client) return not vim.tbl_contains(excluded_lsps, client.name) end
        })
    end,
})

local settings = {
    ["neovim"]             = { opts = { setup = false } },
    ["vim-fugitive"]       = { opts = { setup = false } },
    ["nvim-notify"]        = { name = "notify" },
    ["vim-tmux-navigator"] = { opts = { setup = false } },
    ["copilot.vim"]        = { opts = { setup = false } },
    ["snacks.nvim"]        = {
        opts = {
            terminal = {
                enabled = true
            }
        }
    },
    ["nvim-lspconfig"]     = {
        opts = {
            lua_ls = {
                settings = {
                    Lua = {
                        inlay_hints = true,
                        workspace = { checkThirdParty = false },
                        diagnostics = {
                            globals = { "vim" },
                            disable = { "missing-fields" },
                        },
                        completion = {
                            callSnippet = "Replace",
                        }
                    }
                },
                capabilities = vim.tbl_deep_extend(
                    "force",
                    vim.lsp.protocol.make_client_capabilities(),
                    { window = { workDoneProgress = true } }
                )
            },
            ts_ls = {},
            pyright = {},
            yamlls = {},
            bashls = {},
            gopls = {},
            rust_analyzer = {}
        }
    },

    ["fzf-lua"]            = {
        opts = {
            files = {
                rg_opts = "--color=never --files --hidden --follow -g '!.git' -g '!.next'",
                fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude .next",
            }
        }
    },

    ['blink.cmp']          = {
        opts = {
            signature = { enabled = true },
            cmdline = {
                enabled = false
            },
            completion = {
                accept = {
                    auto_brackets = {
                        enabled = true,
                    }
                },
                documentation = { auto_show = true, auto_show_delay_ms = 200 },
                ghost_text = {
                    enabled = vim.g.ai_cmp
                },
                menu = {
                    draw = {
                        treesitter = { 'lsp' },
                    }
                }
            }
        }
    },
    fidget                 = {
        opts = {
            integration = {
                ["nvim-tree"] = {
                    enable = false,
                },
            },
            notification = {
                window = {
                    normal_hl = "String", -- Base highlight group in the notification window
                    winblend = 0,         -- Background color opacity in the notification window
                    border = "rounded",   -- Border around the notification window
                    zindex = 45,          -- Stacking priority of the notification window
                    max_width = 0,        -- Maximum width of the notification window
                    max_height = 0,       -- Maximum height of the notification window
                    x_padding = 1,        -- Padding from right edge of window boundary
                    y_padding = 1,        -- Padding from bottom edge of window boundary
                    align = "bottom",     -- How to align the notification window
                    relative = "editor",  -- What the notification window position is relative to
                },
            },
        }
    },
    lualine                = {
        opts = {
            globalstatus = true,
            sections = {
                lualine_b = { { 'branch', icon = { "" } }, 'diff', 'diagnostics' },
                lualine_c = {
                    {
                        "filename",
                        path = 2,
                        file_status = true,
                    },
                },
            }
        }
    }
}

-- Auto processing of plugins
local delList = {}
for _, plugin in ipairs(vim.pack.get()) do
    -- Delete plugins that are not active
    if not plugin.active then
        vim.notify("Deleting inactive plugin: " .. plugin.spec.name, vim.log.levels.INFO)
        table.insert(delList, plugin.spec.name)
    end
    if delList and #delList > 0 then
        vim.pack.del(delList)
    end

    -- Setup plugins, pulling in settings if defined
    local p = plugin.spec.name
    if string.find(p, ".nvim$") then
        p = string.sub(p, 1, -6) -- Remove the .nvim suffix
    end
    local o = {}
    if settings[p] then
        if settings[p].opts then
            o = settings[p].opts
        end
        if settings[p].name then
            p = settings[p].name
        else
        end
    end
    if p == "nvim-lspconfig" then
        for name, lsp in pairs(o) do
            vim.lsp.enable(name)
            vim.lsp.config(name, lsp or {})
        end
    else
        if o.setup == false then
            print("Skipping setup for plugin: " .. p)
        else
            local ok, mod = pcall(require, p)
            if ok then
                mod.setup(o)
            else
                vim.notify(mod, vim.log.levels.WARN)
            end
        end
    end
end

require('options')
require('mappings')
