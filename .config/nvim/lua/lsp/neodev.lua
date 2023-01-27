require('lspconfig').sumneko_lua.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
            completion = {
                callSnippet = "Replace"
            }
        }
    }
})
