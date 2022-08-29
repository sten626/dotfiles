# shellcheck shell=bash

# Include .bashrc if it exists.

bashrc_file="$HOME/.bashrc"
if [[ -f "$bashrc_file" ]]; then
  # shellcheck source=./.bashrc
  . "$bashrc_file"
fi
unset bashrc_file
