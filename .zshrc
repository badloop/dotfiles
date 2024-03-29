# User defined functions
function v() {
    if [ -f ./venv/bin/activate ]; then
        . venv/bin/activate
    fi
}

# zsh vi mode
autoload edit-command-line
zle -N edit-command-line
zstyle :zle:edit-command-line editor nvim
bindkey -v
bindkey -M vicmd vv edit-command-line

# Zoxide
eval "$(zoxide init zsh)"

# Key Bindings
bindkey -s '^F' 'sesh connect $(sesh list -tz | fzf)^M'

# Work Proxy
function proxy() {
    if [ -z "$1" ]; then
        echo "Usage: 'proxy up' or 'proxy down'"
    fi

    case $1 in
        up)
            echo "Enabling proxy..."
            export http_proxy=work:8028
            export HTTP_PROXY=work:8028
            export https_proxy=work:8028
            export HTTPS_PROXY=work:8028
	    export STARSHIP_CONFIG="/home/aaron/.config/starship_w_kub.toml"
            ;;
        down)
            echo "Disabling proxy..."
            unset http_proxy
            unset HTTP_PROXY
            unset https_proxy
            unset HTTPS_PROXY
            export STARSHIP_CONFIG="/home/aaron/.config/starship.toml"
            ;;
    esac
}

export STARSHIP_CONFIG="/home/aaron/.config/starship.toml"
# Starship kube config
if [ -n "${http_proxy}" ]; then
    export STARSHIP_CONFIG="/home/aaron/.config/starship_w_kub.toml"
fi

# Re-encode raw video file
function encode() {
    if [ -z "$1" ]; then
        echo "Please provide a filename to convert..."
        kill -INT $$
    fi
    if [ -z "$2" ]; then
        echo "Please provide a target filename..."
        kill -INT $$
    fi

    ffmpeg -i "${1}" -preset fast -crf 22 -tune film -level 4 -colorspace bt709 "${2}"
}

# Rename epsiodes based on timestamp
function rename() {
    IFS=$'\n'
    if [ -z "$1" ]; then
        echo "Please provide filter text as first argument"
        kill -INT $$
    fi
    filter=$1
    curr_files=($(find ./ -type f | grep -e "E[0-9]\{2\}\.*"))
    curr_count=$(echo "${#curr_files[@]}");
    # Allow reindexing of the entire dir
    if [[ "${filter}" == "E" ]]; then
        curr_count=0
    fi
    echo "Current files: $curr_files"
    echo "Current count: $curr_count"
    allfiles=(*.(mkv|mp4)(NOm))
    for f in $allfiles; do
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
export JAVA_HOME=/usr/lib/jvm/default
export GIT_EDITOR=nvim
export STARSHIP_DISABLE_KUBERNETES=true

export PATH=$PATH:/usr/local/bin:$GOPATH/bin
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$PATH:$PYENV_ROOT/bin
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/Desktop
export PATH=$PATH:~/.bun/bin


# ~/.tmux/plugins
export PATH=$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
# ~/.config/tmux/plugins
export PATH=$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH

export DISPLAY=:0.0

export LS_COLORS=$(vivid generate catppuccin-mocha)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

systemctl --user import-environment DISPLAY

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv shell 3.10.10

# Aliases
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias vim='v;nvim'
alias colors='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done'
alias ls="eza --git --icons --header --group"
# alias tmux="tmux -L"
alias hist="history 1"
alias cat="bat"

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

# bun completions
[ -s "/home/aaron/.bun/_bun" ] && source "/home/aaron/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -f ~/.fzf.colors ] && source ~/.fzf.colors
