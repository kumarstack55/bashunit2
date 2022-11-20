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

calc::_print_app_usage() {
  : # TODO: implement here
}

calc::app() {
  local opt

  while getopts AMh opt; do
    case $opt in
      h) calc::_print_app_usage;;
      *) calc::_print_app_usage;;
    esac
  done
  shift $((OPTIND-1))
  if [ $# -ne 2 ]; then
    calc::_print_app_usage
  fi

  calc::add "$1" "$2"
}

calc::test_app_prints_usage_when_h_option_exists() {
  local result

  result=$(calc::app -h)

  # shellcheck disable=SC2181
  [[ $? -eq 1 ]] || calc::_die
  [[ "$result" =~ 'Usage:' ]] || calc::_die
}

calc::test_app_prints_usage_when_unknown_option_exists() {
  local result

  result=$(calc::app -x)

  # shellcheck disable=SC2181
  [[ $? -eq 1 ]] || calc::_die
  [[ "$result" =~ 'Usage:' ]] || calc::_die
}

calc::test_app_prints_usage_when_number_of_arguments_is_not_two() {
  local result

  result=$(calc::app 10 20 30)

  # shellcheck disable=SC2181
  [[ $? -eq 1 ]] || calc::_die
  [[ "$result" =~ 'Usage:' ]] || calc::_die
}

calc::test_app_caluculate_add() {
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
