local M = {}

function M.load(env_path)
  local vars = {}
  env_path = env_path or (vim.fn.getcwd() .. "/.env")
  if vim.fn.filereadable(env_path) == 1 then
    for line in io.lines(env_path) do
      if line:match("^%s*$") or line:match("^%s*#") then
        goto continue
      end
      local key, value = line:match("^([^=]+)=(.*)$")
      if key and value then
        value = value:gsub("^['\"]", ""):gsub("['\"]$", "")
        vars[key] = value
      end
      ::continue::
    end
  end
  return vars
end

function M.print(vars)
  vars = vars or M.load()
  local lines = {"[dap-env] Loaded environment variables:"}
  for k, v in pairs(vars) do
    table.insert(lines, string.format("%s=%s", k, v))
  end
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

return M
