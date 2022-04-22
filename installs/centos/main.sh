#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" && . ../../utils.sh

install_package() {
  local -r package=$1

  if yum list installed "$package" &> /dev/null; then
    print_success "$package"
    return 0
  fi

  execute \
    "sudo yum install --quiet $package" \
    "$package"
}

update() {
  execute \
    "sudo yum update --quiet" \
    "yum (update)"
}

update
install_package "htop"
