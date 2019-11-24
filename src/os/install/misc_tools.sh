#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "utils.sh"

print_in_purple "\n   Miscellaneous Tools\n\n"

install_package "cURL" "curl"
install_package "htop" "htop"
install_package "shellcheck" "shellcheck"
install_package "traceroute" "traceroute"
install_package "unzip" "unzip"
install_package "whois" "whois"
install_package "xclip" "xclip"
