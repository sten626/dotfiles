#!/bin/bash

declare -r GITHUB_REPOSITORY="sten626/dotfiles"

declare -r DOTFILES_UTILS_URL="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/master/src/os/utils.sh"

declare skipQuestions=false

download() {
    local url="$1"
    local outfile="$2"

    if command -v "curl" &> /dev/null; then
        curl -LsSo "$outfile" "$url" &> /dev/null
        #     │││└─ write output to file
        #     ││└─ show error messages
        #     │└─ don't show progress meter
        #     └─ follow redirects

        return $?
    elif command -v "wget" &> /dev/null; then
        wget -qO "$outfile" "$url" &> /dev/null
        #     │└─ write output to file
        #     └─ don't show output

        return $?
    fi

    return 1
}

download_utils() {
    local tmpFile=""

    tmpFile="$(mktemp /tmp/XXXXX)"

    download "$DOTFILES_UTILS_URL" "$tmpFile" \
        && . "$tmpFile" \
        && rm -rf "$tmpFile" \
        && return 0

    return 1
}

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

    if [ -x "utils.sh" ]; then
        . "utils.sh" || exit 1
    else
        download_utils || exit 1
    fi

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
