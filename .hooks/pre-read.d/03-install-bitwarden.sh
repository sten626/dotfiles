#!/bin/bash

set -euo pipefail

# 1. Install Bitwarden CLI if it doesn't exist
if ! command -v bw &> /dev/null; then
    echo "Bitwarden CLI not found. Installing..."
    pnpm add --global @bitwarden/cli
fi

# 2. Check Bitwarden login status and login if not logged in
BW_STATUS=$(bw status 2>/dev/null | grep -o '"status": "[^"]*"' | cut -d '"' -f 4)

if [ "$BW_STATUS" = "unauthenticated" ]; then
    echo "Bitwarden CLI is not logged in. Logging in..."
    bw login
fi
