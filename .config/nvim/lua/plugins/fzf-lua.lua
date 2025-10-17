return {
    "ibhagwan/fzf-lua",
    opts = {
        "telescope",
        "fzf-native",
        fzf_opts = {
            ["--layout"] = "default",
            ["--exact"] = "",
        },
        files = {
            cmd = "rg --files --no-ignore -g '!venv/' -g '!.git/' -g '!node_modules/' --color=never --hidden --smart-case",
            cwd_prompt = false,
        },
        grep = {
            cmd = "rg --vimgrep --no-ignore -g '!venv/' -g '!.git/'  -g '!node_modules/' --color=never --hidden --smart-case --column --line-number",
            cwd_prompt = false,
        },
    },
}
