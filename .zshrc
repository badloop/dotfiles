# User defined functions
function v() {
    if [ -f ./venv/bin/activate ]; then
        . venv/bin/activate
    fi
}

# Exports
export TERM=xterm-256color
export BASH_SILENCE_DEPRECATION_WARNING=1
export PYENV_ROOT=${HOME}/.pyenv
export GO111MODULE="on"
export GOPRIVATE="dev.azure.com"
export GOPATH=$(go env GOPATH)
export PATH=$PATH:/usr/local/bin:$GOPATH/bin
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$PATH:$PYENV_ROOT/bin
export DISPLAY=:0.0

systemctl --user import-environment DISPLAY

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv shell 3.10.10

# Aliases
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias vim='v;nvim'
alias colors='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done'
alias ls="ls --color=auto"

# Completions
autoload -U compinit; compinit
zstyle ':completion:*:*:cp:*' file-sort size
zstyle ':completion:*' file-sort modification

# Rust
source "$HOME/.cargo/env"

# Autosuggestions
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Prompt
eval "$(starship init zsh)"
