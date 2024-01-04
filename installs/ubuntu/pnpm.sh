#!/bin/bash

install_package() {
  execute "pnpm install --global $1" "$1"
}

main() {
  cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . ../../utils.sh \
    && . ./utils.sh

  execute "curl -fsSL https://get.pnpm.io/install.sh | sh -" "pnpm"
  # shellcheck disable=SC1091
  . "$HOME/.bashrc"

  install_package "@angular/cli"
  install_package "eslint"
  install_package "sass"
  install_package "typescript"
}

main
