#!/bin/bash

main() {
  cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . ../../utils.sh \
    && . ./utils.sh

  update
  install_package "htop"
}

main
