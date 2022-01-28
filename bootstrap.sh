#!/usr/bin/bash
# This file is for syncing the dotfiles into my home directory. It is meant to
# be sourced, not executed. This is because it needs to source the new
# `.bash_profile`.

function sync_files() {
  cd "$(dirname "${BASH_SOURCE[0]}")" || exit

  rsync \
    --archive \
    --human-readable \
    --verbose \
    --files-from=./files_to_sync.txt \
    . "$HOME"
  . "$HOME/.bash_profile"
}

function main() {
  local force=false

  while getopts 'f' flag; do
    case "${flag}" in
      f) force=true ;;
      *) usage
         exit 1 ;;
    esac
  done

  if [ $force = true ]; then
    sync_files
  else
    read -r -n 1 -p "This may overwrite existing files in your home directory. Continue? (y/n) "
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      sync_files
    fi
  fi
}

main
unset main sync_files
