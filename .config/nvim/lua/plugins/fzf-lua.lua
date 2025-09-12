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
            cmd = " rg --files -g '!venv/' --color=never --hidden",
            cwd_prompt = false,
        },
    },
}
