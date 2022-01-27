#!/usr/bin/bash

function main() {
  cd "$(dirname "${BASH_SOURCE[0]}")" || exit

  rsync --archive --human-readable --verbose --files-from=./files_to_sync.txt . "$HOME"
  . "$HOME/.bash_profile"
}

main
unset main
