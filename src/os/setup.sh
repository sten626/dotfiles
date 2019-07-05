#!/bin/bash

declare -r GITHUB_REPOSITORY="sten626/dotfiles"

declare -r DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/tarball/master"
declare -r DOTFILES_UTILS_URL="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/master/src/os/utils.sh"

declare dotfilesDirectory="$HOME/workspace/dotfiles"
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

download_dotfiles() {
    local tmpFile=""

    print_in_purple "\n • Download and extract archive\n\n"

    tmpFile="$(mktemp /tmp/XXXXX)"

    download "$DOTFILES_TARBALL_URL" "$tmpFile"
    print_result $? "Download archive" "true"
    printf "\n"

    if ! $skipQuestions; then
        ask_for_confirmation "Do you want to store the dotfiles in '$dotfilesDirectory'?"

        if ! answer_is_yes; then
            dotfilesDirectory=""

            while [ -z "$dotfilesDirectory" ]; do
                ask "Please specify another location for the dotfiles (path): "
                dotfilesDirectory="$(get_answer)"
            done
        fi

        # Ensure the 'dotfiles' directory is available

        while [ -e "$dotfilesDirectory" ]; do
            ask_for_confirmation "'$dotfilesDirectory' already exists, do you want to overwrite it?"

            if answer_is_yes; then
                rm -rf "$dotfilesDirectory"
                break
            else
                dotfilesDirectory=""

                while [ -z "$dotfilesDirectory" ]; do
                    ask "Please specify another location for the dotfiles (path): "
                    dotfilesDirectory="$(get_answer)"
                done
            fi
        done

        printf "\n"
    else
        rm -rf "$dotfilesDirectory" &> /dev/null
    fi

    mkdir -p "$dotfilesDirectory"
    print_result $? "Create '$dotfilesDirectory'" "true"

    # Extract archive in the `dotfiles` directory.

    extract "$tmpFile" "$dotfilesDirectory"
    print_result $? "Extract archive" "true"

    rm -rf "$tmpFile"
    print_result $? "Remove archive"

    cd "$dotfilesDirectory/src/os" \
        || return 1
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

extract() {
    local archive="$1"
    local outputDir="$2"

    if command -v "tar" &> /dev/null; then
        tar -zxf "$archive" --strip-components 1 -C "$outputDir"
        return $?
    fi

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

    # If the script was run independantly the rest of the files will need to be downloaded.

    printf "%s" "${BASH_SOURCE[0]}" | grep "setup.sh" &> /dev/null \
        || download_dotfiles

    ./create_directories.sh "$@"

    ./create_symbolic_links.sh "$@"

    ./create_local_config_files.sh
}

main "$@"
