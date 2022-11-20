#!/bin/bash
mypackage::test_1_returns_zero() {
  return 0
}

mypackage::test_2_exits_zero() {
  exit 0
}

mypackage::test_3_returns_zero() {
  return 0
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
