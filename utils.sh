#!/bin/bash

execute() {
  local -r cmd="$1"
  local -r msg="${2-$1}"
  local -r frames='/-\|'
  local -r n_frames=${#frames}
  local -r tmpFile="$(mktemp /tmp/XXXXX)"

  # Create handler for killing subprocesses on exit if we don't already have one.
  trap -p EXIT | grep kill_all_subprocesses &> /dev/null \
    || trap kill_all_subprocesses EXIT

  eval "$cmd" &> "$tmpFile" &
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

  kernelName="$(uname --kernal-name)"

  if [ "$kernelName" == "Linux" ] && [ -e "/etc/os-release" ]; then
    os="$(. /etc/os-release; echo "$ID")"
  else
    os="$kernelName"
  fi

  echo "$os"
}

is_wsl() {
  if grep --extended-regexp --ignore-case --quiet "(microsoft|wsl)" /proc/version &> /dev/null; then
    return 0
  else
    return 1
  fi
}

kill_all_subprocesses() {
  local pid=""

  for pid in $(jobs -p); do
    kill "$pid"
    wait "$pid" &> /dev/null
  done
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
