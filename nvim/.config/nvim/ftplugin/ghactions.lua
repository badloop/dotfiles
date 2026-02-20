-- GitHub Actions log file settings
-- Provides ANSI color rendering via baleia and folding on ##[group]/##[endgroup]

local bufnr = vim.api.nvim_get_current_buf()

-- Apply baleia to render ANSI escape codes
if vim.g.baleia then
  vim.g.baleia.once(bufnr)
end

-- Custom fold expression for ##[group]/##[endgroup]
local function ghactions_foldexpr(lnum)
  local line = vim.fn.getline(lnum)

  -- Start a fold on ##[group]
  if line:match("##%[group%]") then
    return ">1"
  end

  -- End a fold on ##[endgroup]
  if line:match("##%[endgroup%]") then
    return "<1"
  end

  -- Otherwise, keep the same fold level
  return "="
end

-- Custom fold text to show the group name
local function ghactions_foldtext()
  local line = vim.fn.getline(vim.v.foldstart)
  -- Extract the group name after ##[group]
  local group_name = line:match("##%[group%](.*)") or "group"
  -- Strip ANSI codes from the group name for display
  group_name = group_name:gsub("\027%[[%d;]*m", "")
  local line_count = vim.v.foldend - vim.v.foldstart + 1
  return "▶ " .. group_name .. " (" .. line_count .. " lines)"
end

-- Make fold functions global so they can be called by foldexpr/foldtext
_G.GHActionsFoldExpr = ghactions_foldexpr
_G.GHActionsFoldText = ghactions_foldtext

-- Set fold options for this buffer
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.GHActionsFoldExpr(v:lnum)"
vim.opt_local.foldtext = "v:lua.GHActionsFoldText()"
vim.opt_local.foldlevel = 0 -- Start with all folds closed
vim.opt_local.foldenable = true

-- Make the buffer read-only (logs shouldn't be edited)
vim.opt_local.readonly = true
vim.opt_local.modifiable = false

-- Disable line wrapping for cleaner log viewing
vim.opt_local.wrap = false

-- Keymaps for navigation
local opts = { buffer = bufnr, silent = true }

-- Jump to next/previous group
vim.keymap.set("n", "]]", function()
  vim.fn.search("##\\[group\\]", "W")
end, vim.tbl_extend("force", opts, { desc = "Next group" }))

vim.keymap.set("n", "[[", function()
  vim.fn.search("##\\[group\\]", "bW")
end, vim.tbl_extend("force", opts, { desc = "Previous group" }))

-- Jump to next/previous error
vim.keymap.set("n", "]e", function()
  vim.fn.search("##\\[error\\]", "W")
end, vim.tbl_extend("force", opts, { desc = "Next error" }))

vim.keymap.set("n", "[e", function()
  vim.fn.search("##\\[error\\]", "bW")
end, vim.tbl_extend("force", opts, { desc = "Previous error" }))

-- Jump to next/previous warning
vim.keymap.set("n", "]w", function()
  vim.fn.search("##\\[warning\\]", "W")
end, vim.tbl_extend("force", opts, { desc = "Next warning" }))

vim.keymap.set("n", "[w", function()
  vim.fn.search("##\\[warning\\]", "bW")
end, vim.tbl_extend("force", opts, { desc = "Previous warning" }))

-- Toggle all folds
vim.keymap.set("n", "<leader>z", "zA", vim.tbl_extend("force", opts, { desc = "Toggle all folds recursively" }))

-- Smart h/l navigation for folds
-- l opens fold if on a closed fold, otherwise normal l
vim.keymap.set("n", "l", function()
  local foldclosed = vim.fn.foldclosed(vim.fn.line("."))
  if foldclosed ~= -1 then
    vim.cmd("normal! zo")
  else
    vim.cmd("normal! l")
  end
end, vim.tbl_extend("force", opts, { desc = "Move right or open fold" }))

-- h closes fold if at column 1 or on a fold line, otherwise normal h
vim.keymap.set("n", "h", function()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  local foldlevel = vim.fn.foldlevel(vim.fn.line("."))
  
  -- If at beginning of line and inside a fold, close the fold
  if col == 1 and foldlevel > 0 then
    vim.cmd("normal! zc")
  else
    vim.cmd("normal! h")
  end
end, vim.tbl_extend("force", opts, { desc = "Move left or close fold" }))
