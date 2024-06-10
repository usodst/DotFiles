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
alias k="kubectl"
alias kube="kubectl"
alias ip="ip -c=auto"
alias l='ls -CF'
alias la='ls -A'
alias lg="lazygit"
alias ll='ls -alF'
alias ls='ls --color=auto'
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
export EDITOR="nvim"
export PATH=~/.cargo/bin/:$PATH
export PATH=~/.local/bin/:$PATH
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# VI mode
set -o vi

# Enable oh-my-posh
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/tokyonight_storm.omp.json)"
