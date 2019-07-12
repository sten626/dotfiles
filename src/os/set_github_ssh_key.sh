#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

add_ssh_configs() {
    printf "%s\n" \
        "Host github.com" \
        "  IdentityFile $1" \
        "  LogLevel ERROR" >> ~/.ssh/config

    print_result $? "Add SSH configs"
}

copy_public_ssh_key_to_clipboard() {
    if cmd_exists "pbcopy"; then
        pbcopy < "$1"
        print_result $? "Copy public SSH key to clipboard"
    elif cmd_exists "xclip"; then
        xclip -selection clip < "$1"
        print_result $? "Copy public SSH key to clipboard"
    else
        print_warning "Please copy the public SSH key ($1) to clipboard"
    fi
}

generate_ssh_keys() {
    ask "Please provide an email address: " && printf "\n"
    ssh-keygen -t rsa -b 4096 -C "$(get_answer)" -f "$1"

    print_result $? "Generate SSH keys"
}

open_github_ssh_page() {
    declare -r GITHUB_SSH_URL="https://github.com/settings/ssh"
}
