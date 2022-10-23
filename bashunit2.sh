#!/bin/bash

declare -a _bashunit2_tests

_bashunit2_err() { echo "${1:-}" >&2; }

_bashunit2_die() {
  _bashunit2_err "${1:-Died} at ${BASH_SOURCE[1]} line ${BASH_LINENO[0]}."
  exit 1
}

_bashunit2_print_functions() {
  local _ f
  while read -r _ _ f; do echo "$f"; done < <(declare -F)
}

_bashunit2_print_tests() {
  local f
  while read -r f; do
    if [[ $f =~ ^test_ ]]; then echo "$f"; fi
  done < <(_bashunit2_print_functions)
}

_bashunit2_print_self_tests() {
  local f
  while read -r f; do
    if [[ $f =~ ^_bashunit2_self_test_ ]]; then echo "$f"; fi
  done < <(_bashunit2_print_functions)
}

_bashunit2_discover_tests() {
  local f
  while read -r f; do
    _bashunit2_tests+=("$f")
  done < <(_bashunit2_print_tests)
}

_bashunit2_run_tests() {
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

bashunit2_run_tests() {
  _bashunit2_tests=()
  _bashunit2_discover_tests
  _bashunit2_run_tests
}

_bashunit2_self_test_run_tests_continues_when_test_exits_with_zero() {
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

  actual=$(bashunit2_run_tests "$@")

  # shellcheck disable=SC2181
  [ $? -eq 0 ] || return 1

  diff -u <(echo "$expected") <(echo "$actual")
}

_bashunit2_self_test_run_tests_fails_when_test_returns_non_zero() {
  local expected actual

  test_returns_zero() { return 1; }

  read -r -d '' expected <<__EXPECTED__
TAP version 14
1..1
not ok - test_returns_zero
__EXPECTED__

  actual=$(bashunit2_run_tests "$@")

  # shellcheck disable=SC2181
  [ $? -ne 0 ] || return 1

  diff -u <(echo "$expected") <(echo "$actual")
}

_bashunit2_self_test_run_tests_fails_when_test_exits_with_non_zero() {
  local expected actual

  test_exits_non_zero() { exit 1; }

  read -r -d '' expected <<__EXPECTED__
TAP version 14
1..1
not ok - test_exits_non_zero
__EXPECTED__

  actual=$(bashunit2_run_tests "$@")

  # shellcheck disable=SC2181
  [ $? -ne 0 ] || return 1

  diff -u <(echo "$expected") <(echo "$actual")
}

_bashunit2_run_self_tests() {
  local ok=y _ f st

  while read -r f; do
    _bashunit2_err "$f()"
    ( $f )
    st=$?
    _bashunit2_err "exit status: $st"
    if [ $st -ne 0 ]; then
      ok=
    fi
    _bashunit2_err
  done < <(_bashunit2_print_self_tests)

  [ "$ok" ] || _bashunit2_die "Tests failed."
  _bashunit2_err "All tests were successfully completed."
}

_bashunit2_assert_eq() {
  local e="$1" a="$2"
  if [[ "$e" != "$a" ]]; then
    _bashunit2_err "expected: '$e', actual: '$a'"
    return 1
  fi
  return 0
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  _bashunit2_run_self_tests
fi
