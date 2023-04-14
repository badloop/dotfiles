# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# Aliases
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias vim='v;nvim'
alias colors='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done'

# Rust
source "$HOME/.cargo/env"

# Prompt
eval "$(starship init zsh)"
# source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
