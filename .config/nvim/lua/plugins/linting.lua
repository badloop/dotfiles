return {
    "mfussenegger/nvim-lint",
    opts = {
        -- Event to trigger linters
        events = { "BufWritePost", "BufReadPost", "InsertLeave" },
        linters_by_ft = {
            javascriptreact = { "eslint" },
            typescriptreact = { "eslint" },
            javascript = { "eslint" },
            typescript = { "eslint" },
            python = { "pylint" },
        },
        linters = {
            pylint = {
                args = {
                    "-f",
                    "json",
                    "--enable-all-extensions",
                    "-d",
                    "C0199,R0902,R0913,R0914,R2004,R6103,W0717",
                    "--init-hook",
                    "import sys;import os;sys.path.append(os.getcwd());sys.path.append([r+'/'+d[0] for r, d, f in os.walk('.') if 'site-packages' in d][0])",
                },
            },
        },
    },
    config = function(_, opts)
        local M = {}
        local lint = require("lint")

        for name, linter in pairs(opts.linters) do
            if type(linter) == "table" and type(lint.linters[name]) == "table" then
                lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
            else
                lint.linters[name] = linter
            end
        end

        lint.linters_by_ft = vim.tbl_deep_extend("force", lint.linters_by_ft, opts.linters_by_ft)
        function M.debounce(ms, fn)
            local timer = vim.loop.new_timer()
            return function(...)
                local argv = { ... }
                timer:start(ms, 0, function()
                    timer:stop()
                    vim.schedule_wrap(fn)(unpack(argv))
                end)
            end
        end

        function M.lint()
            local names = lint._resolve_linter_by_ft(vim.bo.filetype)

            -- Add fallback linters.
            -- if #names == 0 then
            -- 	vim.list_extend(names, lint.linters_by_ft["_"] or {})
            -- end

            -- Add global linters.
            -- vim.list_extend(names, lint.linters_by_ft["*"] or {})

            -- Run linters.
            if #names > 0 then
                lint.try_lint(names)
            end
        end

        vim.api.nvim_create_autocmd(opts.events, {
            group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
            callback = M.debounce(100, M.lint),
        })
    end,
}
