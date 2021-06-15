#!/bin/bash

echo_title() {
  local len=$((${#1} + 2))
  seq -s "-" 0 $len | tr -d '[0-9]'
  echo " $1 "
  seq -s "-" 0 $len | tr -d '[0-9]'
}
