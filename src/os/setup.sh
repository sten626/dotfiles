#!/bin/bash

declare skipQuestions=false

verify_os() {
    declare -r MINIMUM_UBUNTU_VERSION="16.04"

    local os_name="$(get_os)"
    local os_version="$(get_os_version)"

    # Check is the OS is Ubuntu and above the required version.

    if [ "$os_name" == "ubuntu" ]; then
        if is_supported_version "$os_version" "$MINIMUM_UBUNTU_VERSION"; then
            return 0
        else
            printf "Sorry, this script is intended only for Ubuntu %s+" "$MINIMUM_UBUNTU_VERSION"
        fi
    else
        printf "Sorry, this script is intended only for Ubuntu!"
    fi

    return 1
}

main() {
    # Ensure that the following actions are made relative to this file's path.
    
    cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

    # Load utils

    . "utils.sh" || exit 1

    # Ensure the OS is supported

    verify_os || exit 1

    skip_questions "$@" \
        && skipQuestions=true

    ask_for_sudo

    ./create_directories.sh "$@"

    ./create_symbolic_links.sh "$@"

    ./create_local_config_files.sh
}

main "$@"
