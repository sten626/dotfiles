#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && . ../../utils.sh \
  && . ./utils.sh

update() {
  execute \
    "sudo apt-get update -qq" \
    "apt (update)"
}

upgrade() {
  execute \
    "export DEBIAN_FRONTEND=noninteractive && sudo apt-get --option Dpkg::Options::=\"--force-confnew\" upgrade -qq" \
    "apt (upgrade)"
}

main() {
  update
  upgrade
  install_package "build-essential"
  install_package "git"
  ../nvm.sh
  ./misc.sh
  ../npm.sh
}

main
