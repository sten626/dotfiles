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

    if cmd_exists "xdg-open"; then
        xdg-open "$GITHUB_SSH_URL"
    elif cmd_exists "open"; then
        open "$GITHUB_SSH_URL"
    else
        print_warning "Please add the public SSH key to GitHub ($GITHUB_SSH_URL)"
    fi
}

set_github_ssh_key() {
    local ssh_key_file_name="$HOME/.ssh/github"

    # If the file already exists, generate a new unique file.
    
    if [ -f "$ssh_key_file_name" ]; then
        ssh_key_file_name="$(mktemp -u "$HOME/.ssh/github_XXXXX")"
    fi

    generate_ssh_keys "$ssh_key_file_name"
    add_ssh_configs "$ssh_key_file_name"
    copy_public_ssh_key_to_clipboard "${ssh_key_file_name}.pub"
    open_github_ssh_page
    test_ssh_connection \
        && rm "${ssh_key_file_name}.pub"
}

test_ssh_connection() {
    while true; do
        ssh -T git@github.com &> /dev/null
        [ $? -eq 1 ] && break

        sleep 5
    done
}

main() {
    print_in_purple "\n • Set up GitHub SSH keys\n\n"

    if ! is_git_repository; then
        print_error "Not a Git repository"
        exit 1
    fi

    ssh -T git@github.com &> /dev/null

    if [ $? -ne 1 ]; then
        set_github_ssh_key
    fi

    print_result $? "Set up GitHub SSH keys"
}

main
