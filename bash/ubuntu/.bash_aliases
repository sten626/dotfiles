# shellcheck shell=bash

# Apt

alias apti='sudo apt install'

# Update node to newest LTS version

alias nu='nvm install lts/* --reinstall-packages-from=node'

# Install updates from apt and npm

alias u='sudo apt update \
            && sudo apt upgrade \
            && npm install --global npm \
            && npm upgrade --global'
