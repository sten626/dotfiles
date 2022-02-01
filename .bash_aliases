# shellcheck shell=bash

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  # shellcheck disable=SC2015
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Shortcuts
alias c='clear'
alias g='git'
alias m='man'
alias n='npm'
alias w='cd $HOME/workspace'

# Apt
alias apti="sudo apt install"

# Update node to newest LTS version
alias nu="nvm install lts/* --reinstall-packages-from=node"

# Install updates from apt and npm
alias u="sudo apt update \
            && sudo apt upgrade \
            && npm install --global npm \
            && npm upgrade --global"
