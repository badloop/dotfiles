local adapters = require("dap").adapters
adapters.chromium = {
    type = 'executable',
    command = 'node',
    args = { vim.fn.resolve(vim.fn.stdpath('data') .. '/lazy/vscode-js-debug') }
}
