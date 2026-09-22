#!/bin/bash

# XDG Base Directory Specification
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

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

path_append "$HOME/bin"
path_append "$HOME/.local/bin"

export PATH
