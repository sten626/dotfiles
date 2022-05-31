#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && . ../../utils.sh \
  && . ./utils.sh

install_package "curl"
install_package "shellcheck"
install_package "xclip"
