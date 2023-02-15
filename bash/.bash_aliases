# shellcheck shell=bash

# Navigation

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Enable color support of ls and also add handy aliases

if [[ -x /usr/bin/dircolors ]]; then
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
alias s='switchto'
alias w='cd $HOME/workspace'

# Kill

alias k='kill'
alias k9='kill -9'
alias ku1='kill -USR1'

# WSL

if [[ -n $WSL ]]; then
  alias open='explorer.exe'
fi

# Enable any OS specific aliases

bash_dir="$(dirname "$(readlink "${BASH_SOURCE[0]}")")"
os_aliases_file="$bash_dir/$OS/.bash_aliases"

if [[ -f "$os_aliases_file" ]]; then
  # shellcheck disable=SC1090
  . "$os_aliases_file"
fi

unset bash_dir os_aliases_file
