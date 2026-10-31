# shellcheck shell=bash

# Make a new directory and move into it.
mkd() {
  mkdir -p "$@" && cd "$_" || return 1
}

# Recursively replace all instances of a string in all files in PWD with another string.
replace_all() {
  local -r old="$1"
  local -r new="$2"

  grep --files-with-matches --recursive "$old" --exclude-dir=.git | xargs sed --in-place "s|$old|$new|g"
}

# Excluding my old tar functions for now; may add back later.
