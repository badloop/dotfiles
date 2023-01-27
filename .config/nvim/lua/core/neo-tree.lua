require("neo-tree").setup({
    auto_close = false,
    close_if_last_window = false,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    sort_case_insensitive = false,
    open_on_setup = false,
    filesystem = {
        filtered_items = {
            hide_dotfiles = false,
            hide_hiddeen = false,
            hide_gitignored = false,
        }
    },
    default_component_configs = {
        symbols = {
            -- Change type
            added     = "✚",
            deleted   = "✖",
            modified  = "",
            renamed   = "",
            -- Status type
            untracked = "",
            ignored   = "",
            unstaged  = "",
            staged    = "",
            conflict  = "",
        }
    },
    window = {
        position = 'float'
    }
})
