#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

install_npm_package() {
    declare -r PACKAGE_READABLE_NAME="$1"
    declare -r PACKAGE="$2"

    if ! npm_package_is_installed "$PACKAGE"; then
        execute \
            ". $HOME/.bash.local \
                && npm install --global $PACKAGE" \
            "$PACKAGE_READABLE_NAME"
    else
        print_success "$PACKAGE_READABLE_NAME"
    fi
}

install_npx_package() {
    execute \
        ". $HOME/.bash.local \
            && npx $2 install --global" \
        "$1"
}

npm_package_is_installed() {
    npm list --global "$1" &> /dev/null
}

main() {
    print_in_purple "\n   npm\n\n"

    install_npm_package "npm (update)" "npm"

    install_npm_package "Angular CLI" "@angular/cli"
    install_npm_package "eslint" "eslint"
    install_npm_package "ts-node" "ts-node"
    install_npm_package "tslint" "tslint"
    install_npm_package "TypeScript" "typescript"

    install_npx_package "npm-merge-driver" "npm-merge-driver"
}

main
