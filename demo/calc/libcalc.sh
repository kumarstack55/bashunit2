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

  # shellcheck disable=SC2181
  [[ $? -eq 0 ]] || calc::_die
  [[ "$result" -eq 3 ]] || calc::_die
}

calc::multiply() {
  local n1="$1" n2="$2"
  echo $((n1*n2))
}

calc::test_multiply_positive_values() {
  local result

  result=$(calc::multiply 2 3)

  # shellcheck disable=SC2181
  [[ $? -eq 0 ]] || calc::_die
  [[ "$result" -eq 6 ]] || calc::_die
}

calc::test_multiply_positive_and_negative_values() {
  local result

  result=$(calc::multiply 2 -3)

  # shellcheck disable=SC2181
  [[ $? -eq 0 ]] || calc::_die
  [[ "$result" -eq -6 ]] || calc::_die
}

calc::_print_app_usage() {
  cat <<__USAGE__
Usage:
  $ calc.sh [options...] value1 value2

Options:
  -A      add 'VALUE1' and 'VALUE2' (default)
  -M      multiply 'VALUE1' and 'VALUE2'
  -h      print this message

Examples:
  Outputs the answer 1 + 2.
    $ ./calc.sh 1 2

  Outputs the answer 2 * 3.
    $ ./calc.sh -M 2 3
__USAGE__

  exit 1
}

calc::app() {
  local opt operation

  operation="add"
  while getopts AMh opt; do
    case $opt in
      h) calc::_print_app_usage;;
      A) operation="add";;
      M) operation="multiply";;
      *) calc::_print_app_usage;;
    esac
  done
  shift $((OPTIND-1))
  if [ $# -ne 2 ]; then
    calc::_print_app_usage
  fi

  if [[ "$operation" == "add" ]]; then
    calc::add "$1" "$2"
  elif [[ "$operation" == "multiply" ]]; then
    calc::multiply "$1" "$2"
  else
    echo "Internal error" >&2
    exit 1
  fi
}

calc::test_app_prints_usage() {
  local result

  result=$(calc::app -h)

  # shellcheck disable=SC2181
  [[ $? -eq 1 ]] || calc::_die
  [[ "$result" =~ 'Usage:' ]] || calc::_die
}

calc::test_app_fails_when_too_many_arguments_given() {
  local result

  result=$(calc::app 1 2 3)

  # shellcheck disable=SC2181
  [[ $? -eq 1 ]] || calc::_die
}

calc::test_app_add() {
  local result

  result=$(calc::app 1 2)

  # shellcheck disable=SC2181
  [[ $? -eq 0 ]] || calc::_die
  [[ "$result" == 3 ]] || calc::_die
}

calc::test_app_multiply() {
  local result

  result=$(calc::app -M 2 3)

  # shellcheck disable=SC2181
  [[ $? -eq 0 ]] || calc::_die
  [[ "$result" == 6 ]] || calc::_die
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
