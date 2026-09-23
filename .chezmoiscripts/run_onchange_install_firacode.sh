#!/bin/bash

set -euo pipefail

FONTS_DIR="$HOME/.local/share/fonts"

mkdir --parents "$FONTS_DIR"

if [ -f "$FONTS_DIR/NerdFonts/FiraCodeNerdFontMono-Regular.ttf" ]; then
  echo "FiraCode Nerd Font already installed"
  exit 0
fi

sh -c "$(curl --silent --show-error https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh)" -- install FiraCode
