#!/bin/bash
file_actual_stdout_txt=actual_stdout.txt
file_actual_stdout_diff=actual_stdout.diff
file_actual_stderr_txt=actual_stderr.txt
file_actual_stderr_diff=actual_stderr.diff
file_actual_exit_status_txt=actual_exit_status.txt
file_actual_exit_status_diff=actual_exit_status.diff

die() {
  echo "${1:-Died.}"
  exit 1
}

cleanup() {
  rm -f "$file_actual_stdout_txt" "$file_actual_stdout_diff" \
    "$file_actual_stderr_txt" "$file_actual_stderr_diff" \
    "$file_actual_exit_status_txt" "$file_actual_exit_status_diff"
}

run_unittest() {
  # This function uses `declare -p` to define a global variable.
  # It is expected to be executed within a sub-process to avoid affecting
  # the caller's namespace.

  local ok=y
  local out_diff err_diff ret_diff

  # shellcheck disable=SC1090
  . <(
    {
      err=$(
        {
          # shellcheck disable=SC2030
          out=$(./unittest.sh)
          # shellcheck disable=SC2030
          ret=$?
        } 2>&1
        declare -p out ret >&2
      )
      declare -p err
    } 2>&1
  )

  # Ignore shellcheck warnings.
  # shellcheck disable=SC2031
  : "${out:=}" "${err:=}" "${ret:=}"

  if ! out_diff=$(diff -u <(echo -n "$out") "./expected_stdout.txt"); then
    ok=
    echo -n "$out" >"./${file_actual_stdout_txt}"
    echo "$out_diff" >"./${file_actual_stdout_diff}"
  fi

  if ! err_diff=$(diff -u <(echo -n "$err") ./expected_stderr.txt); then
    ok=
    echo -n "$err" >"./${file_actual_stderr_txt}"
    echo "$err_diff" >"./${file_actual_stderr_diff}"
  fi

  if ! ret_diff=$(diff -u <(echo "$ret") ./expected_exit_status.txt); then
    ok=
    echo "$ret" >"./${file_actual_exit_status_txt}"
    echo "$ret_diff" >"./${file_actual_exit_status_diff}"
  fi

  [ "$ok" ]
}

print_unittest_dirs() {
  local e

  for e in *; do
    if [ -d "$e" ]; then
      echo "$e"
    fi
  done
}

run_unittests() {
  local d ok=y

  while read -r d; do
    echo "$d"
    pushd "$d" >/dev/null || exit 1
    cleanup
    if ! ( run_unittest ); then
      ok=
      echo "test failed: '$d'."
    fi
    popd >/dev/null || exit 1
  done < <(print_unittest_dirs)
  [ "$ok" ]
}

main() {
  local script_dir

  script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
  cd "$script_dir" || exit 1

  if ! run_unittests; then
    die "Test failed."
  fi

  echo "All tests were successfully completed."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
