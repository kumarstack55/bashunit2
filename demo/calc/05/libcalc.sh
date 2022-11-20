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

calc::app() {
  : # TODO: implement here
}

calc::test_app_prints_usage() {
  local result

  result=$(calc::app -h)

  # shellcheck disable=SC2181
  [[ $? -eq 1 ]] || exit 1
  [[ "$result" =~ 'Usage:' ]] || exit 1
}

calc::test_app_add() {
  local result

  result=$(calc::app 1 2)

  # shellcheck disable=SC2181
  [[ $? -eq 0 ]] || exit 1
  [[ "$result" == 3 ]] || exit 1
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
