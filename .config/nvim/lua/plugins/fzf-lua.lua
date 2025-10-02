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
            cmd = "rg --files --no-ignore -g '!venv/' -g '!.git/' --color=never --hidden",
            cwd_prompt = false,
        },
    },
}
