#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

main() {
    print_in_purple "\n • Restart\n\n"

    ask_for_confirmation "Do you want to source the new configuration files?"
    printf "\n"

    if answer_is_yes; then
        . "$HOME/.bash_profile"
    fi
}

main
