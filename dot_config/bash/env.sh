#!/bin/bash

path_remove() {
  local -r path_to_remove="$1"
  [ -n "$path_to_remove" ] || return 0
  PATH=":$PATH:"
  PATH="${PATH//:$path_to_remove:/:}"
  PATH="${PATH#:}"
  PATH="${PATH%:}"
}

path_append() {
  local -r path_to_append="$1"
  [ -n "$path_to_append" ] || return 0
  path_remove "$path_to_append"
  PATH="${PATH:+$PATH:}$path_to_append"
}

path_prepend() {
  local -r path_to_prepend="$1"
  [ -n "$path_to_prepend" ] || return 0
  path_remove "$path_to_prepend"
  PATH="$path_to_prepend${PATH:+:$PATH}"
}

path_prepend "$HOME/bin"
path_prepend "$HOME/.local/bin"

# NVM
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
path_prepend "$PNPM_HOME/bin"
# pnpm end


export PATH
