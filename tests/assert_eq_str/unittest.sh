#!/bin/bash
mypackage::test_assert_eq_str_ok() {
  bashunit2::assert_eq_str "a" "a"
}

mypackage::test_assert_eq_str_not_ok() {
  bashunit2::assert_eq_str "a" "b"
}

mypackage::run_tests() {
  local script_dir bashunit2_path

  script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
  bashunit2_path="$script_dir/../../bashunit2.sh"

  # shellcheck source=../../bashunit2.sh
  source "$bashunit2_path"

  bashunit2::run_tests "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  mypackage::run_tests "$@"
fi
