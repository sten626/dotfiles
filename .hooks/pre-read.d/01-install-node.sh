#!/bin/bash

set -euo pipefail

# shellcheck source=/dev/null
NVM_DIR="$HOME/.config/nvm"

# 1. Install nvm if it doesn't exist
if [ ! -d "$NVM_DIR" ]; then
  echo "nvm not found. Installing..."
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" "$(git rev-list --tags --max-count=1)")"
fi

# 2. Load nvm into the current subshell
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# 3. Ensure node LTS is installed and active
if ! command -v node &> /dev/null; then
  echo "node not found. Installing LTS version..."
  nvm install --lts
  nvm use --lts
fi
