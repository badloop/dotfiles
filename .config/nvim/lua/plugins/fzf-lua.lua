return {
    "ibhagwan/fzf-lua",
        opts = {
            fzf_opts = {
                ['--layout'] = 'default',
                ['--exact'] = ''
            },
            files = {
                cmd = " rg --files -g '!venv/' --color=never --hidden",
                cwd_prompt = false
            }
        }
}

