-- Detect GitHub Actions log files
-- Matches files with ##[group] markers or downloaded from GitHub Actions

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.ghlog", "*_actions.log" },
  callback = function()
    vim.bo.filetype = "ghactions"
  end,
})

-- Also detect by content for generic .log files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.log",
  callback = function()
    -- Check first 50 lines for GitHub Actions markers
    local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
    for _, line in ipairs(lines) do
      if line:match("##%[group%]") or line:match("##%[error%]") or line:match("##%[warning%]") then
        vim.bo.filetype = "ghactions"
        return
      end
    end
  end,
})
