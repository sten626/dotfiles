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

execute() {
  local -r cmd="$1"
  local -r msg="${2-$1}"
  local -r frames='/-\|'
  local -r n_frames=${#frames}
  local -r tmpFile="$(mktemp /tmp/XXXXX)"

  # Create handler for killing subprocesses on exit if we don't already have one.
  trap -p EXIT | grep kill_all_subprocesses &> /dev/null \
    || trap kill_all_subprocesses EXIT

  eval "$cmd" > /dev/null 2> "$tmpFile" &
  local cmdPid=$!
  local i=0
  local frameText=""

  while kill -0 "$cmdPid" &> /dev/null; do
    frameText="   [${frames:i++%n_frames:1}] $msg"
    printf "%s" "$frameText"
    sleep 0.2
    printf "\r"
  done

  wait "$cmdPid" &> /dev/null
  local exitCode=$?

  if [ "$exitCode" -eq 0 ]; then
    print_success "$msg"
  else
    print_error "$msg"
    print_error_stream < "$tmpFile"
  fi

  rm -rf "$tmpFile"

  return $exitCode
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

kill_all_subprocesses() {
  local pid=""

  for pid in $(jobs -p); do
    kill "$pid"
    wait "$pid" &> /dev/null
  done
}

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
      # mv "$dst" "$backup"
      print_success "Moved $dst to $backup"
    elif $overwrite || $overwrite_all; then
      # rm -rf "$dst"
      print_success "Removed $dst"
    elif $skip || $skip_all; then
      print_success "Skipped $src"
    fi
  fi

  if ! $skip && ! $skip_all; then
    # ln --symbolic "$src" "$dst"
    print_success "Linked $dst → $src"
  fi
}

print_error() {
  print_in_red "   [✖] $1\n"
}

print_error_stream() {
  while read -r line; do
    print_error "↳ ERROR: $line"
  done
}

print_in_colour() {
  printf "%b" "$(tput setaf "$2" 2> /dev/null)$1$(tput sgr0 2> /dev/null)"
}

print_in_cyan() {
  print_in_colour "$1" 6
}

print_in_green() {
  print_in_colour "$1" 2
}

print_in_red() {
  print_in_colour "$1" 1
}

print_in_yellow() {
  print_in_colour "$1" 3
}

print_question() {
  print_in_yellow "   [?] $1"
}

print_success() {
  print_in_green "   [✔] $1\n"
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
