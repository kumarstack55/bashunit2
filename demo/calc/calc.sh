#!/bin/bash

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck source=./libcalc.sh
source "$script_dir/libcalc.sh"

usage() {
  cat <<__USAGE__
$ calc.sh [options...] value1 value2

Options:
  -h      print this message

Examples:
  Outputs the answer 1 + 2.
    $ ./calc.sh 1 2
__USAGE__

  exit 1
}

main() {
  local opt
  while getopts h opt; do
    case $opt in
      h) usage;;
      *) usage;;
    esac
  done
  shift $((OPTIND-1))

  if [ $# -ne 2 ]; then
    usage
  fi

  calc_add "$1" "$2"
}

main "$@"
