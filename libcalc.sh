#!/bin/bash

calc::add() {
  local n1="$1" n2="$2"
  echo $((n1+n2))
}

calc::test_add() {
  local result
  result=$(calc::add 1 2)
  [[ "$result" -eq 3 ]]
}

calc::multiply() {
  local n1="$1" n2="$2"
  echo $((n1*n2))
}

calc::test_multiply() {
  local result
  result=$(calc::multiply 2 3)
  [[ "$result" -eq 6 ]]
}

calc::run_tests() {
  local script_dir

  script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
  # shellcheck source=./bashunit2.sh
  source "$script_dir/bashunit2.sh"

  bashunit2::run_tests "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  calc::run_tests "$@"
fi
