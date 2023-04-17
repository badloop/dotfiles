export BASH_SILENCE_DEPRECATION_WARNING=1
export PYENV_ROOT=${HOME}/.pyenv
export GO111MODULE="on"
export GOPRIVATE="dev.azure.com"
export GOPATH=$(go env GOPATH)
export PATH=$PATH:/usr/local/bin:$GOPATH/bin:$PYENV_ROOT/bin
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv shell 3.10.10

function venv() {
    python3 -m venv venv
}

function cv() {
    python -m venv venv
}

function v() {
    . venv/bin/activate
}

function myvim() {
    . ./venv/bin/activate
    nvim $1
}

function google() {
    query=$1
    site=$2
    open "https://www.google.com/search?q=${1}&as_sitesearch=${2}"
}

alias config="/usr/bin/git --git-dir=${HOME}/.cfg/ --work-tree=${HOME}"
alias vim="myvim"
alias g="google"
alias tmux='tmux -f ~/.config/tmux/tmux.conf'
set -o vi
. "$HOME/.cargo/env"
