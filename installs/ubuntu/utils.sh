#!/bin/bash

install_package() {
  local -r package=$1

  # Check if already installed.
  if package_is_installed "$1"; then
    print_success "$package"
    return 0
  fi

  execute \
    "sudo apt-get install --allow-unauthenticated -qq $package" \
    "$package"
}

package_is_installed() {
  dpkg --status "$1" &> /dev/null
}
