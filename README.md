# bashunit2

bashunit2 is a framework for TAP compliant testing.

## Features

* You can include your test codes in your library.
* There is only one file that you need to depend on for testing: bashunit2.sh.

## Requirements

* Bash 5.0+

## Quickstart

Write the test first. Let's name the file `libcalc.sh`.

```bash
#!/bin/bash

calc_add() {
  : # TODO: Implement here
}

test_add() {
  local expected=3 actual
  actual=$(calc_add 1 2)
  [[ "$expected" == "$actual" ]]
}
```

Add some codes so that tests can be run.

```bash
#!/bin/bash

calc_add() {
  : # TODO: Implement here
}

test_add() {
  local expected=3 actual
  actual=$(calc_add 1 2)
  [[ "$expected" == "$actual" ]]
}

run_tests() {
  source "./bashunit2.sh"
  bashunit2_run_tests "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_tests "$@"
fi
```

Run the test to make sure it fails.

```console
$ ./libcalc.sh
TAP version 14
1..1
not ok - test_add
```

Write an implementation of the function `calc_add()`.

```bash
#!/bin/bash

calc_add() {
  local n1="$1" n2="$2"
  echo $((n1+n2))
}

test_add() {
  local expected=3 actual
  actual=$(calc_add 1 2)
  [[ "$expected" == "$actual" ]]
}

run_tests() {
  source "./bashunit2.sh"
  bashunit2_run_tests "$@"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  run_tests "$@"
fi
```

Run the test again to verify that the test passes.

```console
$ ./libcalc.sh
TAP version 14
1..1
ok - test_add
```

You can run the test in another way.

```console
$ source libcalc.sh
$ run_tests
TAP version 14
1..1
ok - test_add
```

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

## TODO

* CI

## Similar projects

* [Bats-core](https://github.com/bats-core/bats-core)
* [shUnit2](https://github.com/kward/shunit2)
* [bashunit](https://github.com/djui/bashunit)
* [bashUnit](https://github.com/athena-oss/bashunit)
* [ShellSpec](https://github.com/shellspec/shellspec)