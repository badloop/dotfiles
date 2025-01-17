-- vim.cmd([[highlight Normal guibg=none]])
-- vim.cmd([[highlight NonText guibg=none]])
-- vim.cmd([[highlight TelescopeBorder guibg=none]])
-- vim.cmd([[highlight FloatBorder guibg=none]])
-- vim.cmd([[highlight ColorColumn guibg=#16161D]])
vim.cmd([[highlight WinSeparator guifg=#bb9af7]])

-- User commands
vim.api.nvim_create_user_command("PreviewCSV", function()
	require("nvim-preview-csv").preview()
	vim.cmd([[set list!]])
end, {})
