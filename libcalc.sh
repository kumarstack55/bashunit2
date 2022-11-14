#!/bin/bash

calc_add() {
  local n1="$1" n2="$2"
  echo $((n1+n2))
}

test_add() {
  local result
  result=$(calc_add 1 2)
  [[ "$result" -eq 3 ]]
}

run_tests() {
  local script_dir
  script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

  # shellcheck source=./bashunit2.sh
  source "$script_dir/bashunit2.sh"

  bashunit2::run_tests "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_tests "$@"
fi
