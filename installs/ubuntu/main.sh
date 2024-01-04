#!/bin/bash

main() {
  cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . ../../utils.sh \
    && . ./utils.sh

  update
  upgrade
  install_package "build-essential"
  install_package "git"
  ./nvm.sh
  ./misc.sh

  ./pnpm.sh
  # ./npm.sh
}

main
