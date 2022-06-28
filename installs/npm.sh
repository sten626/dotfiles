#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" && . ../utils.sh

install_npm_package() {
  execute \
    "npm list --depth=0 --location=global $1 &> /dev/null || npm install --location=global --silent $1" \
    "$1"
}

main() {
  install_npm_package "npm"
  install_npm_package "@angular/cli"
  install_npm_package "eslint"
  install_npm_package "sass"
  install_npm_package "typescript"
}

main
