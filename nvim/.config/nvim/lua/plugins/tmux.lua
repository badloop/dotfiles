return {
    "christoomey/vim-tmux-navigator",
    config = function()
        -- Helper: safely leave terminal mode, then navigate
        local function safe_tmux_navigate(direction)
            local mode = vim.fn.mode()
            if mode == "t" then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
            end
            vim.cmd("TmuxNavigate" .. direction)
        end

        -- Auto-apply these mappings whenever an opencode terminal buffer opens
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "opencode_terminal",
            callback = function(args)
                local opts = { buffer = args.buf, silent = true, noremap = true }
                vim.keymap.set("t", "<C-h>", function()
                    safe_tmux_navigate("Left")
                end, opts)
                vim.keymap.set("t", "<C-j>", function()
                    safe_tmux_navigate("Down")
                end, opts)
                vim.keymap.set("t", "<C-k>", function()
                    safe_tmux_navigate("Up")
                end, opts)
                vim.keymap.set("t", "<C-l>", function()
                    safe_tmux_navigate("Right")
                end, opts)
            end,
        })
        vim.keymap.set("n", "<S-C-u>", function()
            vim.notify("heyo")
            require("opencode").command("messages_half_page_up")
        end, { desc = "Messages half page up" })
        vim.keymap.set("n", "<S-C-d>", function()
            vim.notify("down")
            require("opencode").command("messages_half_page_down")
        end, { desc = "Messages half page down" })
    end,
}
