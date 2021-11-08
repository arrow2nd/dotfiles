#!/bin/bash

echo_title() {
  local len=$((${#1} + 2))

  printf "=%.0s" $(seq $len)
  echo -e "\n $1 "
  printf "=%.0s" $(seq $len)
  echo
}

install() {
    echo_title "Install $1"

    if type "$1" > /dev/null 2>&1; then
        echo "$1 is exist"
    else
        brew install "$1"
    fi
}
