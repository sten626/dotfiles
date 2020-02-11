#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
  && . "../utils.sh"

create_directories() {
  local windows_user=""
  windows_user=$(get_windows_user)
  declare -a DIRECTORIES=(
    "/mnt/c/Users/$windows_user/workspace"
  )

  for i in "${DIRECTORIES[@]}"; do
    mkd "$i"
  done
}

link_workspace() {
  local windows_user=""
  windows_user=$(get_windows_user)
  local -r SOURCE="/mnt/c/Users/$windows_user/workspace"
  local -r TARGET="$HOME/workspace"

  local skipQuestions=false

  skip_questions "$@" \
    && skipQuestions=true

  if [ ! -e "$TARGET" ] || $skipQuestions; then
    execute "ln -fs $SOURCE $HOME" "$TARGET → $SOURCE"
  elif [ "$(readlink "$TARGET")" == "$SOURCE" ]; then
    print_success "$TARGET → $SOURCE"
  else
    if ! $skipQuestions; then
      ask_for_confirmation "'$TARGET' already exists, do you want to overwrite it?"

      if answer_is_yes; then
        rm -rf "$TARGET"
        execute "ln -s $SOURCE $HOME" "$TARGET → $SOURCE"
      else
        print_error "$TARGET → $SOURCE"
      fi
    fi
  fi
}

main() {
  print_in_purple "\n • Create directories\n\n"
  create_directories
  link_workspace "$@"
}

main "$@"
