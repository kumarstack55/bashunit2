# bashunit2

bashunit2 is a framework for TAP compliant testing.

![GitHub Actions](https://github.com/kumarstack55/bashunit2/actions/workflows/ci.yml/badge.svg)

## Features

* You can include your test codes in your library.
* There is only one file that you need to depend on for testing: bashunit2.sh.

## Requirements

* Bash 4.4+

## Quickstart

### Implement your first test function

In this introduction, we will implement a library that does the calculations.
Let's name the file `libcalc.sh`.

As a calculation, implement a function that performs addition.
Name the function `calc_add`.
The function to test that function is called `test_calc_add`.

Let's write the test first.

```bash
#!/bin/bash

add() {
  : # TODO: implement here
}

test_add() {
  local result

  result=$(add 1 2)

  [[ "$result" -eq 3 ]]
}
```

In the test function, run calc_add and if it is as expected, the test function
returns exit status 0.

### Ensure that tests are run when the library is executed

Let's add to this library the ability to do additions and to execute additions
from the shell.

Add some codes so that tests can be run.

```bash
#!/bin/bash

add() {
  : # TODO: implement here
}

test_add() {
  local result

  result=$(add 1 2)

  [[ "$result" -eq 3 ]]
}

run_tests() {
  local script_dir

  script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

  # shellcheck source=./bashunit2.sh
  source "$script_dir/bashunit2.sh"

  bashunit2::run_tests "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_tests "$@"
fi
```

This example assumes that `bashunit2.sh` and `libcalc.sh` are in the same
directory.
However, `bashunit2.sh` can be located anywhere.
It can be in a subdirectory of your project or in a directory higher than the
`libcalc.sh` file.
If it is in a different location, change the contents of the `script_dir`
variable appropriately.

### Run the test and confirm that it fails

You can run the test in your shell by running . /libcalc.sh to run the test.
Run the test to make sure it fails.

```console
$ ./libcalc.sh
TAP version 14
1..1
not ok - test_add
```

### Optional: Rename the function

We could see that the test would fail.
Let's make sure the test succeeds with proper implementation.

By the way, bashunit2 uses Google's Shell Style Guide for function naming
conventions.
Tests are run by executing bashunit2::run_tests.

bashunit2::run_tests means that the Shell Style Guide executes the function
run_tests in the bashunit2 library.

bashunit2 automatically discovers functions to test.
It determines that a function is a test function if its name begins with
`test_` or contains `::test_`.

For this introduction, let's change the function name of libcalc.sh as well,
as follows:

```bash
#!/bin/bash

calc::add() {
  : # TODO: implement here
}

calc::test_add() {
  local result

  result=$(calc::add 1 2)

  [[ "$result" -eq 3 ]]
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
```

Of course, renaming functions in libcalc.sh is not required.
Implement your library any way you like.

### Implement the code and run tests

Write an implementation of the function `calc::add()`.

```bash
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
```

Run the test again to verify that the test passes.

```console
$ ./libcalc.sh
TAP version 14
1..1
ok - test_add
```

Congratulations!
You've implemented calc::add and it passes all your tests!

### Another way to run the test

By the way, you can test in another way as follows:

```console
$ source libcalc.sh
$ calc::run_tests
TAP version 14
1..1
ok - test_add
```

### Implement the application

Next, let's add another function to the library.

Add a function that parses arguments and performs calculations so that users
can perform calculations from the shell.

We write the test as we did for the implementation of the `calc::add()`
function.

We decide on `calc::app` as the function name to implement.
When `calc::app -h` is executed, it outputs the usage.
When an integer is specified, such as `calc::app 2 3`, it performs addition of
the specified values.

```bash
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
```

TODO

<!--

Once you have sufficiently tested the library, you can implement your
application.

Let's name the file `calc.sh`.

```bash
#!/bin/bash

source "./libcalc.sh"

main() {
  calc_add "$1" "$2"
}

main "$@"
```

Let's run the application.

```console
$ ./calc.sh 1 2
3
```

-->

## TODO

* Add assert_*()
* Add document for mock

## Similar projects

* [Bats-core](https://github.com/bats-core/bats-core)
* [shUnit2](https://github.com/kward/shunit2)
* [bashunit](https://github.com/djui/bashunit)
* [bashUnit](https://github.com/athena-oss/bashunit)
* [ShellSpec](https://github.com/shellspec/shellspec)
