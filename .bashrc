# shellcheck shell=bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -f ~/.bash_prompt ]; then
  # shellcheck source=.bash_prompt
  . ~/.bash_prompt
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  # shellcheck source=.bash_aliases
  . ~/.bash_aliases
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
agent_env=~/.ssh/agent.env
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
