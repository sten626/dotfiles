# shellcheck shell=bash

echo ".bash_profile"

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
