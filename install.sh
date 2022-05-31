#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" && . "utils.sh"

ask_for_sudo() {
  # Ask for admin password.
  sudo --validate &> /dev/null

  # Keep sudo alive while script is running.
  while true; do
    sudo --non-interactive true
    sleep 60
    kill -0 "$$" || exit
  done &> /dev/null &
}

# install_packages() {
#   # print_in_cyan "\n • Install packages\n\n"
#   # export DEBIAN_FRONTEND="noninteractive"
#   # execute "sudo apt-get update -qq" "apt (update)"
#   # execute "sudo apt-get upgrade -qq" "apt (upgrade)"
#   ./installs/nvm.sh
#   install_package "build-essential"
#   install_package "curl"
#   # execute \
#   #   "curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -" \
#   #   "Add nodesource repo"
#   # install_package "nodejs"
# }

link_file() {
  local -r src=$1
  local -r dst=$2
  local backup=false
  local overwrite=false
  local skip=false

  if [ -e "$dst" ]; then
    if ! $backup_all && ! $overwrite_all && ! $skip_all; then
      if [ "$src" == "$(readlink "$dst")" ]; then
        skip=true
      else
        print_question "File already exists: $dst ($(basename "$src")), what do you want to do?
       [b]ackup, [B]ackup all, [o]verwrite, [O]verwrite all, [s]kip, [S]kip all? "
        read -n 1 -r action
        printf "\n"

        case "$action" in
          b) backup=true;;
          B) backup_all=true;;
          o) overwrite=true;;
          O) overwrite_all=true;;
          s) skip=true;;
          S) skip_all=true;;
          *) ;;
        esac
      fi
    fi

    if $backup || $backup_all; then
      backup="$dst.backup"
      execute \
        "mv $dst $backup" \
        "Backup $dst to $backup"
    elif $overwrite || $overwrite_all; then
      execute \
        "rm -rf $dst" \
        "Remove old $dst"
    elif $skip || $skip_all; then
      print_success "Skip $src"
    fi
  fi

  if ! $skip && ! $skip_all; then
    execute \
      "ln --symbolic $src $dst" \
      "$dst → $src"
  fi
}

symlink_dotfiles() {
  local backup_all=false
  local overwrite_all=false
  local skip_all=false

  print_in_cyan "\n • Create symbolic links\n\n"
  shopt -s globstar nullglob

  for src in "$PWD"/bash/.*
  do
    if [ -f "$src" ]; then
      dst="$HOME/$(basename "$src")"
      link_file "$src" "$dst"
    fi
  done
}

verify_os() {
  if $1; then
    # force=true
    return 0
  fi

  os="$(get_os)"

  if [ "$os" == "ubuntu" ]; then
    return 0
  else
    echo "This script is currently only tested with Ubuntu. Use the -f option to run anyway."
  fi

  return 1
}

main() {
  local force=false

  while :; do
    case $1 in
      -f|--force) force=true;;
               *) break;;
    esac

    shift 1
  done

  verify_os "$force" || exit 1
  ask_for_sudo
  symlink_dotfiles
  ./installs/main.sh
}

main "$@"
