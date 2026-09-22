#!/bin/bash

set -euo pipefail

# shellcheck source=/dev/null
NVM_DIR="$HOME/.config/nvm"

if [ -d "$NVM_DIR" ]; then
  cd "$NVM_DIR"
  git fetch --tags origin
else
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
fi

git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" "$(git rev-list --tags --max-count=1)")"
# shellcheck source=/dev/null
. "$NVM_DIR/nvm.sh"
nvm install node
