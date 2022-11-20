#!/bin/bash

declare -a _bashunit2_tests
declare _bashunit2_test_function_filter=''

bashunit2::_err() {
  echo "bashunit2: ${1:-}" >&2
}

bashunit2::_die() {
  bashunit2::_err "${1:-Died} at ${BASH_SOURCE[1]} line ${BASH_LINENO[0]}."
  exit 1
}

bashunit2::_print_functions() {
  local _ f
  while read -r _ _ f; do echo "$f"; done < <(declare -F)
}

bashunit2::_print_tests() {
  local f
  while read -r f; do
    if [[ $f =~ ^test_ || $f =~ ::test_ ]]; then
      echo "$f"
    fi
  done < <(bashunit2::_print_functions)
}

bashunit2::_print_filtered_tests() {
  local f
  while read -r f; do
    if [[ $f =~ $_bashunit2_test_function_filter ]]; then
      echo "$f"
    fi
  done < <(bashunit2::_print_tests)
}

bashunit2::_discover_tests() {
  local f

  _bashunit2_tests=()
  while read -r f; do
    _bashunit2_tests+=("$f")
  done < <(bashunit2::_print_filtered_tests)

  if [[ ${#_bashunit2_tests[@]} -eq 0 ]]; then
    bashunit2::_err "Could not find any tests."
    return 1
  fi

  return 0
}

bashunit2::_run_tests() {
  echo "TAP version 14"
  echo "1..${#_bashunit2_tests[@]}"

  local ok=y t
  for t in "${_bashunit2_tests[@]}"; do
    # The test function may execute exit.
    # We execute the command in a sub-process to continue processing.
    if ( $t ); then
      echo "ok - $t"
    else
      echo "not ok - $t"
      ok=
    fi
  done

  [ "$ok" ]
}

bashunit2::_usage() {
  while read -r line; do
    echo "$line" >&2
  done <<__USAGE__
Usage: bashunit2::run_tests [OPTION]...

  -f PATTERN    Filter by regular expression PATTERN for the function name
                to be tested.
  -h            display this help and exit.
__USAGE__
}

bashunit2::run_tests() {
  local opt

  while getopts f:h opt; do
    case "$opt" in
      f) _bashunit2_test_function_filter="$OPTARG";;
      h) bashunit2::_usage; return 1;;
      *) bashunit2::_usage; return 1;;
    esac
  done
  shift $((OPTIND-1))

  bashunit2::_discover_tests && bashunit2::_run_tests
}

bashunit2::assert_eq_str() {
  local e="$1" a="$2"
  if [[ "$e" != "$a" ]]; then
    bashunit2::_err "expected: '$e', actual: '$a'"
    return 1
  fi
  return 0
}

# TODO: Remove deprecated function.
# This function exists for backward compatibility.
bashunit2_run_tests() {
  bashunit2::_err '[DEPRECATED] This function will be removed in the future.'
  bashunit2::run_tests
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  bashunit2::run_tests "$@"
fi
