require 'lspconfig'.sumneko_lua.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
                disable = {
                    'assign-type-mismatch'
                }
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true)
            },
        }
    }
}
