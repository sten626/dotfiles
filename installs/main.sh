#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" && . ../utils.sh

print_in_cyan "\n • Install packages\n\n"

os="$(get_os)"
readonly os
readonly os_installer="./$os/main.sh"

# shellcheck disable=SC1090
if [[ -f $os_installer ]]; then
  . "$os_installer"
else
  print_success "No package installer found for $os."
fi
