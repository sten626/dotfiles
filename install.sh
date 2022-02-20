#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

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

get_os() {
  local os=""
  local kernelName=""

  kernelName="$(uname -s)"

  if [ "$kernelName" == "Linux" ] && [ -e "/etc/os-release" ]; then
    if grep --extended-regexp --ignore-case --quiet "(microsoft|wsl)" /proc/version &> /dev/null; then
      os="wsl"
    else
      os="$(. /etc/os-release; echo "$ID")"
    fi
  else
    os="$kernelName"
  fi

  echo "$os"
}

link_file() {
  local src=$1 dst=$2
  local backup=false
  local overwrite=false
  local skip=false

  if [ -e "$dst" ]; then
    if [ "$backup_all" == false ] && [ "$overwrite_all" == false ] && [ "$skip_all" == false ]; then
      if [ "$src" == "$(readlink $dst)" ]; then
        skip=true
      else
        print_question "File already exists: $dst ($(basename "$src")), what do you want to do?
       [b]ackup, [B]ackup all, [o]verwrite, [O]verwrite all, [s]kip, [S]kip all? "
        read -n 1 -r action

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

    backup=${backup-$backup_all}
    overwrite=${overwrite-$overwrite_all}
    skip=${skip-$skip_all}

    if [ "$overwrite" == true ]; then
      rm -rf "$dst"
    fi
  fi
}

print_in_colour() {
  printf "%b" "$(tput setaf "$2" 2> /dev/null)$1$(tput sgr0 2> /dev/null)"
}

print_in_cyan() {
  print_in_colour "$1" 6
}

print_in_yellow() {
  print_in_colour "$1" 3
}

print_question() {
  print_in_yellow "   [?] $1"
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

  if [ "$os" == "wsl" ]; then
    return 0
  else
    echo "This script is currently only tested with WSL. Use the -f option to run anyway."
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
}

main "$@"
