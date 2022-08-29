#!/bin/bash

install_latest_node_lts() {
  execute "nvm install --lts" "nvm (install node)"
}

install_nvm() {
  execute \
    "git clone --quiet https://github.com/nvm-sh/nvm.git $nvm_dir" \
    "nvm (install)"
}

update_nvm() {
  execute \
    "cd $nvm_dir && git fetch --tags origin && git checkout \$(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))" \
    "nvm (update)"
}

main() {
  cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . ../../utils.sh \
    && . ./utils.sh

  local -r nvm_dir="$HOME/.nvm"

  # Install nvm, or update it if already installed.
  if [[ ! -d "$nvm_dir" ]]; then
    install_nvm
  else
    update_nvm
  fi

  # Load nvm in case it was just installed.
  . "$nvm_dir/nvm.sh"

  # Install node LTS
  install_latest_node_lts
}

main
