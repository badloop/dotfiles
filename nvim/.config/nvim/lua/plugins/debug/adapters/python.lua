local adapters = require("dap").adapters
-- Get python from the virtual environment in the current working directory
local get_python_path = function()
    local venv_path = vim.fn.getcwd() .. "/.venv/bin/python"
    if vim.fn.filereadable(venv_path) == 1 then
        return venv_path
    else
        return "python"
    end
end
adapters.python = {
    type = "executable",
    command = get_python_path(),
    args = { "-m", "debugpy.adapter" },
}
