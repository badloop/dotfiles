#
export LANG=en_US.UTF-8

# ZINIT
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "${ZINIT_HOME}" ]; then
    mkdir -p "$(dirname "${ZINIT_HOME}")"
    git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi
# shellcheck disable=1091
source "${ZINIT_HOME}/zinit.zsh"

# ZSH Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit ice as"command" from"gh-r" \
    atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
    atpull"%atclone" src"init.zsh"
zinit light starship/starship

# User defined functions
function v() {
    if [ -f ./venv/bin/activate ]; then
        # shellcheck disable=1091
        source venv/bin/activate
    fi
}

# zsh syntax highlighting configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main brackets pattern)
typeset -A ZSH_HIGHLIGHT_PATTERNS
ZSH_HIGHLIGHT_PATTERNS+=('GET' bg=green,fg=black)
ZSH_HIGHLIGHT_PATTERNS+=('POST' bg=magenta,fg=black)
ZSH_HIGHLIGHT_PATTERNS+=('PUT' bg=yellow,fg=black)
ZSH_HIGHLIGHT_PATTERNS+=('DELETE' bg=17,fg=ffffff)
ZSH_HIGHLIGHT_PATTERNS+=('INFO' fg=cyan)

# Bind Ctrl+O to run "opencode"
function _launch_opencode() {
  zle -I                     # flush any pending input
  BUFFER="opencode"          # put the command in the buffer
  zle accept-line            # execute it
}
zle -N _launch_opencode
bindkey '^O' _launch_opencode


# zsh vi mode
autoload edit-command-line
zle -N edit-command-line
zstyle :zle:edit-command-line editor nvim
bindkey -v
bindkey -M vicmd vv edit-command-line

# Zoxide
eval "$(zoxide init zsh)"

# Key Bindings
# shellcheck disable=2016
bindkey -s '^F' 'sesh connect $(sesh list -tz | fzf)^M'
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Context switcher
function c() {
    case $1 in
    prod)
        kubectl config use-context aks04-prod-eus
        ;;
    qa)
        kubectl config use-context aks06-dev-eus
        ;;
    dev)
        kubectl config use-context aks08-dev-eus
        ;;
    local)
        kubectl config use-context local
        ;;
    esac
}

function ask() {
    if [ -z "$1" ]; then
        echo "Please ask a question"
    fi
    print $(curl -s -X POST "http://0.0.0.0:11434/api/chat" -d "{\"model\": \"meta-llama-3.1-8b-instruct-abliterated.Q8_0.gguf:latest\", \"stream\": false, \"messages\": [{ \"role\": \"user\", \"content\": \"${1}\"}]}" | jq ".message.content") | bat --language md --style plain
    return 0
}

# Work Proxy
function proxy() {
    if [ -z "$1" ]; then
        echo "Usage: 'proxy up' or 'proxy down'"
    fi

    case $1 in
    up)
        echo "Enabling proxy..."
        export http_proxy=http://work:8028
        export HTTP_PROXY=http://work:8028
        export https_proxy=http://work:8028
        export HTTPS_PROXY=http://work:8028
        export no_proxy=localhost
        # export STARSHIP_CONFIG="/home/aaron/.config/starship_w_kub.toml"
        ;;
    down)
        echo "Disabling proxy..."
        unset http_proxy
        unset HTTP_PROXY
        unset https_proxy
        unset HTTPS_PROXY
        unset no_proxy
        # export STARSHIP_CONFIG="/home/aaron/.config/starship.toml"
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

# History
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
export HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Exports
GOPATH=$(go env GOPATH)
export GOPATH
export PYENV_ROOT=${HOME}/.pyenv
export GO111MODULE="on"
export GOPRIVATE="dev.azure.com"
export TERM=xterm-256color
export BASH_SILENCE_DEPRECATION_WARNING=1
export GIT_EDITOR=nvim
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
export EDITOR=nvim

# PATH
export PATH=$PATH:/usr/local/bin:$GOPATH/bin
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$PATH:$PYENV_ROOT/bin
export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/Desktop
export PATH=$PATH:~/.bun/bin
export PATH=$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
export PATH=$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
export PATH=$HOME/.config/bin/:$PATH

# Shell Integrations
eval "$(fzf --zsh)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv shell $(pyenv latest 3)

# Aliases
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias vim='v;nvim'
alias ls="eza --git --icons --header --group"
alias hist="history 1"
alias cat="bat"

# Completions
autoload -U compinit
compinit
zstyle ':completion:*:*:cp:*' file-sort size
zstyle ':completion:*' file-sort modification
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# Rust
source "$HOME/.cargo/env"

# Autosuggestions
# source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# bun completions
[ -s "/home/aaron/.bun/_bun" ] && source "/home/aaron/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# shellcheck disable=1090
[ -f ~/.config/themes/current/fzf.colors ] && source ~/.config/themes/current/fzf.colors
source "$HOME/.zsh_profile"

# Set color theme for real ttys
if [[ -z $DISPLAY && -z $WAYLAND_DISPLAY && -t 0 ]]; then
  setvtrgb "$HOME/.config/fb/tokyonight.vtrgb"
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/aaron/.lmstudio/bin"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/aaron/.dart-cli-completion/zsh-config.zsh ]] && . /home/aaron/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

