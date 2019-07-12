#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "utils.sh"

print_in_purple "\n   Miscellaneous Tools\n\n"

install_package "cURL" "curl"
install_package "Htop" "htop"
install_package "xclip" "xclip"
