local adapters = require("dap").adapters
adapters.go = function()
    local port = math.random(30000, 40000)
    local config = {
        type = "server",
        port = port,
        executable = {
            command = "dlv",
            args = {
                "dap",
                "--listen",
                "127.0.0.1:" .. port,
            },
        },
        options = {
            initialize_timeout_sec = 20,
        },
    }
    return config
end
