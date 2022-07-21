#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" && . ./utils.sh

NVM_DIR="$HOME/.nvm"

install_latest_node_lts() {
  execute "nvm install --lts" "nvm (install node)"
}

install_nvm() {
  execute \
    "git clone --quiet https://github.com/nvm-sh/nvm.git $NVM_DIR" \
    "nvm (install)"
}

update_nvm() {
  execute \
    "cd $NVM_DIR && git fetch --tags origin && git checkout \$(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))" \
    "nvm (update)"
}

main() {
  # Install nvm, or update it if already installed.
  if [ ! -d "$NVM_DIR" ]; then
    install_nvm
  else
    update_nvm
  fi

  # Load nvm in case it was just installed.
  . "$NVM_DIR/nvm.sh"

  # Install node LTS
  install_latest_node_lts
}

main
