require('dapui').setup({
    icons = { expanded = "", collapsed = "", current_frame = "" },
    layouts = {
        {
            elements = {
                -- Elements can be strings or table with id and size keys.
                'stacks',
                'watches',
                'breakpoints',
                { id = 'scopes', size = 0.5 },
            },
            size = 40, -- 40 columns
            position = 'left',
        },
        {
            elements = {
                'console',
                'repl'
            },
            size = 0.25, -- 25% of total lines
            position = 'bottom',
        },
    },
})
