local adapters = require("dap").adapters

adapters.python = {
	type = "executable",
	command = os.getenv("HOME") .. "/.pyenv/versions/debugpy/bin/python",
	args = { "-m", "debugpy.adapter" },
}

-- adapters.go = function(callback)
--     local stdout = vim.loop.new_pipe(false)
--     local handle
--     local pid_or_err
--     local port = 38697
--     local opts = {
--         stdio = { nil, stdout },
--         args = { "dap", "-l", "127.0.0.1:" .. port },
--         detached = true
--     }
--     handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
--         stdout:close()
--         handle:close()
--         if code ~= 0 then
--             print('dlv exited with code', code)
--         end
--     end)
--     assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
--     stdout:read_start(function(err, chunk)
--         assert(not err, err)
--         if chunk then
--             vim.schedule(function()
--                 require('dap.repl').append(chunk)
--             end)
--         end
--     end)
-- end
--

local goAdapter = function()
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

adapters.go = goAdapter()
