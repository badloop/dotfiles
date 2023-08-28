# User defined functions
function v() {
    if [ -f ./venv/bin/activate ]; then
        . venv/bin/activate
    fi
}

# Rename epsiodes based on timestamp
function rename() {
    IFS=$'\n'
    if [ -z "$1" ]; then
        echo "Please provide filter text as first argument"
        kill -INT $$
    fi
    filter=$1
    curr_files=($(find ./ -type f | grep -e "E[0-9]\{2\}\.mkv"))
    curr_count=$(echo "${#curr_files[@]}");
    # Allow reindexing of the entire dir
    if [[ "${filter}" == "E" ]]; then
        curr_count=0
    fi
    echo "Current files: $curr_files"
    echo "Current count: $curr_count"
    for f in *; do 
        if ! (($curr_files[(Ie)$f])); then
            if [[ $f == *${filter}* ]]; then 
                # echo "CURR: $curr_count"
                curr_count=$((curr_count+1)); 
                # echo "CURR+1: $curr_count"
                strCount=$curr_count; 
                if ((curr_count<10)); then 
                    strCount="0${curr_count}"; 
                fi; 
                echo "$curr_count -> $f -> E$strCount.mkv"; 
                if [ -z "$2" ]; then
                    mv -i "${f}" "E${strCount}.mkv"; 
                fi
            fi; 
        fi
    done
}

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

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
export PATH=$PATH:~/.local/bin
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
alias tmux="tmux; setenv TERM tmux-256color"
alias hist="history 1"

# Completions
autoload -U compinit; compinit
zstyle ':completion:*:*:cp:*' file-sort size
zstyle ':completion:*' file-sort modification
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)

# Rust
source "$HOME/.cargo/env"

# Autosuggestions
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Prompt
eval "$(starship init zsh)"
