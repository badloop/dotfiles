local cfg = require("dap").configurations

local function load_env_file()
    local env_vars = {}
    local env_file = vim.fn.getcwd() .. "/.env"

    -- Check if .env file exists
    if vim.fn.filereadable(env_file) == 1 then
        for line in io.lines(env_file) do
            -- Skip empty lines and comments
            if line:match("^%s*$") == nil and line:match("^%s*#") == nil then
                local key, value = line:match("^([^=]+)=(.*)$")
                if key and value then
                    -- Remove quotes if present
                    value = value:gsub("^['\"]", ""):gsub("['\"]$", "")
                    env_vars[key] = value
                end
            end
        end
    else
        print("Warning: .env file not found in project root")
    end

    return env_vars
end

cfg.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch app.py with .env",
        program = "${workspaceFolder}/app.py",
        console = "integratedTerminal",
        cwd = "${workspaceFolder}",
        env = function()
            -- Load environment variables from .env file
            local env_vars = load_env_file()
            -- Merge with current environment
            for k, v in pairs(vim.fn.environ()) do
                if not env_vars[k] then
                    env_vars[k] = v
                end
            end
            return env_vars
        end,
        justMyCode = false, -- Set to true if you want to debug only your code
        stopOnEntry = false,
        runInTerminal = false,
        subProcess = false,
    },
    {
        type = "python",
        request = "launch",
        name = "Debug with uvicorn module",
        module = "uvicorn",
        args = function()
            -- Dynamically determine the app module
            local app_file = vim.fn.getcwd() .. "/app.py"
            if vim.fn.filereadable(app_file) == 1 then
                return { "app:app", "--reload", "--host", "0.0.0.0", "--port", "9191" }
            else
                return { "main:app", "--reload", "--host", "0.0.0.0", "--port", "9191" }
            end
        end,
        console = "integratedTerminal",
        cwd = "${workspaceFolder}",
        env = function()
            local env_vars = load_env_file()
            for k, v in pairs(vim.fn.environ()) do
                if not env_vars[k] then
                    env_vars[k] = v
                end
            end
            return env_vars
        end,
        justMyCode = false,
        stopOnEntry = false,
        subProcess = false,
    },
    {
        type = "python",
        request = "launch",
        name = "Debug Current File",
        program = "${file}",
        console = "integratedTerminal",
        pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
                return venv .. "/bin/python"
            else
                return "/usr/bin/python"
            end
        end,
    },
    {
        type = "python",
        request = "attach",
        name = "Attach to remote process...",
        connect = {
            host = function()
                return vim.fn.input("Host: ")
            end,
            port = function()
                return vim.fn.input("Port: ")
            end,
        },
        mode = "remote",
        pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
                return venv .. "/bin/python"
            else
                return "/usr/bin/python"
            end
        end,
    },
}
