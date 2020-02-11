#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

autoremove() {
    # Remove packages that are no longer needed.
    execute \
        "sudo apt-get autoremove -qq" \
        "APT (autoremove)"
}

install_package() {
    declare -r EXTRA_ARGUMENTS="$3"
    declare -r PACKAGE="$2"
    declare -r PACKAGE_READABLE_NAME="$1"

    if ! package_is_installed "$PACKAGE"; then
        execute "sudo apt-get install --allow-unauthenticated -qq $EXTRA_ARGUMENTS $PACKAGE" "$PACKAGE_READABLE_NAME"
    else
        print_success "$PACKAGE_READABLE_NAME"
    fi
}

package_is_installed() {
    dpkg -s "$1" &> /dev/null
}

update() {
    execute \
        "sudo apt update -qq" \
        "APT (update)"
}

upgrade() {
    execute \
        "export DEBIAN_FRONTEND=\"noninteractive\" \
            && sudo apt-get -o Dpkg::Options::=\"--force-confnew\" upgrade -qq" \
        "APT (upgrade)"
}
