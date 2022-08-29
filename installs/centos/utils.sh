# shellcheck shell=bash

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
