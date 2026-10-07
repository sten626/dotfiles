#!/bin/bash

set -euo pipefail

# 1. Install pnpm if it doesn't exist
if ! command -v pnpm &> /dev/null; then
    echo "pnpm not found. Installing..."
    npx get-pnpm
fi

# 2. Ensure pnpm binary path is exported for next script
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"