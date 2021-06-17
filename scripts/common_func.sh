#!/bin/bash

echo_title() {
  local len=$((${#1} + 2))

  printf "=%.0s" $(seq $len)
  echo -e "\n $1 "
  printf "=%.0s" $(seq $len)
  echo
}
