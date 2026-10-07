#!/bin/bash

set -euo pipefail

HOOKS_DIR="$(dirname "$0")/pre-read.d"

for script in "$HOOKS_DIR"/*; do
    if [ -f "$script" ]; then
        # 'source' the script so PATH and nvm functions persist to the next script
        # shellcheck source=/dev/null
        if ! . "$script"; then
            echo "Error: Hook $script failed."
            exit 1
        fi
    fi
done