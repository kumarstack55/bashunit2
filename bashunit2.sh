#!/bin/bash

declare -a _bashunit2_tests

bashunit2::_err() { echo "bashunit2: ${1:-}" >&2; }

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
    if [[ $f =~ ^test_ || $f =~ ::test_ ]]; then echo "$f"; fi
  done < <(bashunit2::_print_functions)
}

bashunit2::_print_self_tests() {
  local f
  while read -r f; do
    if [[ $f =~ ^bashunit2::_self_test_ ]]; then echo "$f"; fi
  done < <(bashunit2::_print_functions)
}

bashunit2::_discover_tests() {
  local f

  _bashunit2_tests=()
  while read -r f; do
    _bashunit2_tests+=("$f")
  done < <(bashunit2::_print_tests)

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
    if ( $t ); then
      echo "ok - $t"
    else
      echo "not ok - $t"
      ok=
    fi
  done

  [ "$ok" ]
}

bashunit2::run_tests() {
  bashunit2::_discover_tests && bashunit2::_run_tests
}

bashunit2::_self_test_run_tests_continues_when_test_exits_with_zero() {
  local expected actual

  test_1_returns_zero() { return 0; }
  test_2_exits_zero() { exit 0; }
  test_3_returns_zero() { return 0; }

  read -r -d '' expected <<__EXPECTED__
TAP version 14
1..3
ok - test_1_returns_zero
ok - test_2_exits_zero
ok - test_3_returns_zero
__EXPECTED__

  actual=$(bashunit2::run_tests "$@")

  # shellcheck disable=SC2181
  [ $? -eq 0 ] || return 1

  diff -u <(echo "$expected") <(echo "$actual")
}

bashunit2::_self_test_run_tests_fails_when_test_returns_non_zero() {
  local expected actual

  test_returns_zero() { return 1; }

  read -r -d '' expected <<__EXPECTED__
TAP version 14
1..1
not ok - test_returns_zero
__EXPECTED__

  actual=$(bashunit2::run_tests "$@")

  # shellcheck disable=SC2181
  [ $? -ne 0 ] || return 1

  diff -u <(echo "$expected") <(echo "$actual")
}

bashunit2::_self_test_run_tests_fails_when_test_exits_with_non_zero() {
  local expected actual

  test_exits_non_zero() { exit 1; }

  read -r -d '' expected <<__EXPECTED__
TAP version 14
1..1
not ok - test_exits_non_zero
__EXPECTED__

  actual=$(bashunit2::run_tests "$@")

  # shellcheck disable=SC2181
  [ $? -ne 0 ] || return 1

  diff -u <(echo "$expected") <(echo "$actual")
}

bashunit2::_self_test_run_tests_fails_when_no_tests_found() {
  local expected actual

  read -r -d '' expected <<__EXPECTED__
__EXPECTED__

  # TODO: capture stderr
  actual=$(bashunit2::run_tests "$@")

  # shellcheck disable=SC2181
  [ $? -ne 0 ] || return 1

  diff -u <(echo "$expected") <(echo "$actual")
}

bashunit2::_run_self_tests() {
  local ok=y _ f st

  while read -r f; do
    bashunit2::_err "$f()"

    # The function may exit. To continue testing even if exit is executed,
    # run the test in a child process.
    ( $f )
    st=$?

    bashunit2::_err "exit status: $st"
    if [ $st -ne 0 ]; then
      ok=
    fi
    bashunit2::_err
  done < <(bashunit2::_print_self_tests)

  [ "$ok" ] || bashunit2::_die "Tests failed."
  bashunit2::_err "All tests were successfully completed."
}

bashunit2::_define_functions() {
  # The functions defined here are experimental implementations and
  # are subject to change in the future.
  assert_eq() {
    local e="$1" a="$2"
    if [[ "$e" != "$a" ]]; then
      bashunit2::_err "expected: '$e', actual: '$a'"
      return 1
    fi
    return 0
  }
}

# TODO: This function exists for backward compatibility.
bashunit2_run_tests() {
  bashunit2::_err '[DEPRECATED] This function will be removed in the future.'
  bashunit2::run_tests
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  bashunit2::_run_self_tests "$@"
fi
