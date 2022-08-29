#!/bin/bash

main() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && . ../utils.sh

  print_in_cyan "\n • Install packages\n\n"

  # Detect OS.

  local os
  os="$(get_os)"
  readonly os

  # Run specific installs for OS.

  local -r os_installer="./$os/main.sh"
  if [[ -f "$os_installer" ]]; then
    # shellcheck disable=SC1090
    "$os_installer"
  else
    print_success "No package installer found for $os."
  fi
}

main
