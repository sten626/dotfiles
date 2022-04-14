#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" && . ../../utils.sh

install_package() {
  local -r package=$1

  # Check if already installed.
  if dpkg --status "$package" &> /dev/null; then
    print_success "$package"
    return 0
  fi

  execute \
    "sudo apt-get install --quiet $package" \
    "$package"
}

update() {
  execute "sudo apt-get update -qq" "apt (update)"
}

upgrade() {
  execute "export DEBIAN_FRONTEND=\"noninteractive\" \
    && sudo apt-get upgrade -qq" \
    "apt (upgrade)"
}

update
upgrade
install_package "build-essential"

./nvm.sh
install_package "curl"
