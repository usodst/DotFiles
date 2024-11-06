HISTFILE=~/.zsh_history

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=$HISTSIZE
SAVEHIST=$HISTSIZE

setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# Enable case insensitive completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Editor
EDITOR="/usr/bin/nvim"

# User aliases
alias attach="tmux attach"
alias cat="bat"
alias clar="clear"
alias clera="clear"
alias d="docker"
alias ip="ip -c=auto"
alias k="kubectl"
alias kube="kubectl"
alias l='ls -CF'
alias la='ls -A'
alias lg="lazygit"
alias ll='ls -alFh'
alias ls='ls --color=auto'
alias lynx="lynx -vikeys"
alias tf="terraform"
alias vim="nvim"

# Git aliases
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gcb="git checkout -b"
alias gco="git checkout"
alias gf="git fetch -p"
alias gpull="git pull -r"
alias gpush="git push"
alias gs="git status"

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export PATH=~/.cargo/bin/:$PATH
export PATH=~/.local/bin/:$PATH
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# VI mode
set -o vi

# Enable oh-my-posh
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/nordtron.omp.json)"

# Colors for man pages
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export GROFF_NO_SGR=1
