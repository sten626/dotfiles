#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "utils.sh"

print_in_purple "\n • Installs\n\n"

update
upgrade

./build-essentials.sh
./nvm.sh

./git.sh
./misc_tools.sh
./npm.sh
./vim.sh

./cleanup.sh
