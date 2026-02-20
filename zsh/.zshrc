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

# New project: create a directory under ~/code, add to zoxide, and open in sesh
function newp() {
    local base="$HOME/code"
    local input=""

    # If called with an argument, use it directly; otherwise prompt
    if [[ -n "$1" ]]; then
        input="$1"
    else
        echo -n "New project (~/code/): "
        read -r input
    fi

    # Abort on empty input
    if [[ -z "$input" ]]; then
        echo "Aborted."
        return 1
    fi

    local target="$base/$input"

    # Create the directory
    if [[ -d "$target" ]]; then
        echo "Directory already exists: $target"
    else
        mkdir -p "$target"
        echo "Created: $target"
    fi

    # Add to zoxide so it appears in sesh/zoxide lists
    zoxide add "$target"

    # Connect via sesh (creates tmux session + attaches/switches)
    "$HOME/go/bin/sesh" connect "$target"
}

# JSON FZF
jsonfzf() {
  local key="${1:-name}"

  jq -r -c --arg key "$key" '
    .[] |
    [
      (.[$key] // .id // "<no key>" | tostring),
      (tostring)
    ] | @tsv
  ' | \
  fzf \
    --delimiter=$'\t' \
    --with-nth=1 \
    --preview 'echo {2} | jq .' \
    --preview-window=right:60% | \
  cut -f2 | jq .
}

# Wallpaper picker
function wallpaper() {
    local walldir="$HOME/.local/share/wallpapers"

    if [[ ! -d "$walldir" ]]; then
        echo "Wallpaper directory not found: $walldir"
        return 1
    fi

    local selection
    selection=$(find "$walldir" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.bmp' \) | \
        sort | \
        fzf \
            --border-label "Choose a wallpaper" \
            --preview 'kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}' \
            --preview-window=right:60%)

    [[ -z "$selection" ]] && return 0

    hyprctl hyprpaper preload "$selection"
    hyprctl hyprpaper wallpaper ",$selection"
    hyprctl hyprpaper unload unused
}

# zsh syntax highlighting configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(main brackets pattern)
typeset -A ZSH_HIGHLIGHT_PATTERNS
ZSH_HIGHLIGHT_PATTERNS+=('GET' bg=green,fg=black)
ZSH_HIGHLIGHT_PATTERNS+=('POST' bg=magenta,fg=black)
ZSH_HIGHLIGHT_PATTERNS+=('PUT' bg=yellow,fg=black)
ZSH_HIGHLIGHT_PATTERNS+=('DELETE' bg=red,fg=ffffff)
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

# Ctrl+N: new project via newp.sh (outside tmux; inside tmux use Ctrl+F -> Ctrl+N)
function _launch_newp() {
  zle -I
  BUFFER="$HOME/.config/tmux/scripts/newp.sh --interactive"
  zle accept-line
}
zle -N _launch_newp
bindkey '^n' _launch_newp

# Context switcher - defined in ~/.zsh_profile

# Work Proxy - defined in ~/.zsh_profile

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"
# Starship kube config
if [ -n "${http_proxy}" ]; then
    export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship_w_kub.toml"
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

# XDG
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

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
export GO111MODULE="on"
export GOPRIVATE="" # set in ~/.zsh_profile
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
export PATH=$XDG_CONFIG_HOME/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
export PATH=$XDG_CONFIG_HOME/bin/:$PATH

# Shell Integrations
#
# Load FZF
eval "$(fzf --zsh)"


# FZF
[ -f ~/.config/themes/current/fzf.colors ] && source ~/.config/themes/current/fzf.colors
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS" --preview-window=right,60%"
if [ -z "$TMUX" ]; then
    export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --border'
else
fi

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
zstyle ':fzf-tab:*' popup-min-size 80 12
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1a --color=always $realpath'

# Rust
source "$HOME/.cargo/env"


# fzf-git
source "$XDG_CONFIG_HOME/zsh/fzf-git.sh"

# Autosuggestions
# source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# bun completions
[ -s "${HOME}/.bun/_bun" ] && source "${HOME}/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# shellcheck disable=1090
source "$HOME/.zsh_profile"

# Rose-Pine theme for Linux console (only on real tty, not pseudo-terminals)
if [[ $(tty) =~ /dev/tty[0-9]+ ]]; then
    printf "\033]P0191724
\033]P1eb6f92
\033]P231748f
\033]P3f6c177
\033]P49ccfd8
\033]P5c4a7e7
\033]P6ebbcba
\033]P7e0def4
\033]P86e6a86
\033]P9eb6f92
\033]PA31748f
\033]PBf6c177
\033]PC9ccfd8
\033]PDc4a7e7
\033]PEebbcba
\033]PFe0def4"
    # get rid of artifacts
    clear
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:${HOME}/.lmstudio/bin"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f ${HOME}/.dart-cli-completion/zsh-config.zsh ]] && . ${HOME}/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]


. "$HOME/.local/share/../bin/env"

# opencode
export PATH=${HOME}/.opencode/bin:$PATH
export PATH="$HOME/.npm-global/bin:$PATH"

# fnm
FNM_PATH="${HOME}/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi
