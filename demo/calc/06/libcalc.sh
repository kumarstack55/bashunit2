#!/bin/bash

# shellcheck disable=SC2120
calc::_die() {
  echo "${1:-Died} at ${BASH_SOURCE[1]} line ${BASH_LINENO[0]}."
  exit 1
}

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
  [[ $? -eq 1 ]] || calc::_die
  [[ "$result" =~ 'Usage:' ]] || calc::_die
}

calc::test_app_add() {
  local result

  result=$(calc::app 1 2)

  # shellcheck disable=SC2181
  [[ $? -eq 0 ]] || calc::_die
  [[ "$result" == 3 ]] || calc::_die
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
