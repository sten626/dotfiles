# shellcheck shell=bash
# shellcheck disable=SC1091
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

# Bring in my main scripting utility functions.

. "$(dirname "$(readlink "${BASH_SOURCE[0]}")")/../utils.sh"

# Source exports to setup variables and path.

if [ -f "$HOME/.exports" ]; then
  # shellcheck source=.exports
  . "$HOME/.exports"
fi

# Auto correct minor spelling errors when using `cd`.
shopt -s cdspell

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# append to the history file, don't overwrite it
shopt -s histappend

# Match filenames in a case-insensitive fasion when performing filename exansion.
shopt -s nocaseglob

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -f "$HOME/.bash_prompt" ]; then
  # shellcheck source=.bash_prompt
  . "$HOME/.bash_prompt"
fi

# Alias definitions.

if [ -f "$HOME/.bash_aliases" ]; then
  # shellcheck source=.bash_aliases
  . "$HOME/.bash_aliases"
fi

# Function definitions.

if [ -f "$HOME/.functions" ]; then
  # shellcheck source=.functions
  . "$HOME/.functions"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Load the SSH agent so you don't need to enter the passphrase constantly.
agent_env="$HOME/.ssh/agent.env"
if [ -f "$agent_env" ]; then
  # shellcheck disable=SC1090
  . "$agent_env" > /dev/null
fi
# agent_run_state:
#   0 = agent running w/ key
#   1 = agent running w/o ley
#   2 = agent not running
agent_run_state=$(ssh-add -l > /dev/null 2>&1; echo $?)
if [ ! "$SSH_AUTH_SOCK" ] || [ "$agent_run_state" = 2 ]; then
  (umask 077; ssh-agent >| "$agent_env")
  # shellcheck disable=SC1090
  . "$agent_env" > /dev/null
  ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ "$agent_run_state" = 1 ]; then
  ssh-add
fi

unset agent_env agent_run_state

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# shellcheck disable=SC1090
if [ -f "$HOME/.bash.local" ]; then
  . "$HOME/.bash.local"
fi
