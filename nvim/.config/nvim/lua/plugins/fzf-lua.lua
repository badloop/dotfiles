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
            cmd = "/usr/bin/rg --follow --files --no-ignore -g '!venv/' -g '!.git/' -g '!node_modules/' --color=never --hidden --smart-case",
            cwd_prompt = false,
        },
        grep = {
            cmd = "/usr/bin/rg --follow --vimgrep --no-ignore -g '!venv/' -g '!.git/'  -g '!node_modules/' --color=never --hidden --smart-case --column --line-number",
            cwd_prompt = false,
        },
    },
}
