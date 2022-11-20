# bashunit2

bashunit2 is a framework for TAP compliant testing.

![GitHub Actions](https://github.com/kumarstack55/bashunit2/actions/workflows/ci.yml/badge.svg)

## Features

* You can include your test codes in your library.
* There is only one file that you need to depend on for testing: bashunit2.sh.

## Requirements

* Bash 4.4+

## Quickstart

Write the test first. Let's name the file `libcalc.sh`.

```bash
<!-- include path="../demo/calc/01/libcalc.sh" -->
```

libcalc.sh is a library that performs calculations.
Let's add to this library the ability to do additions and to execute additions
from the shell.

Add some codes so that tests can be run.

```bash
<!-- include path="../demo/calc/02/libcalc.sh" -->
```

This example assumes that bashunit2.sh and libcalc.sh are in the same
directory.
However, bashunit2.sh can be located anywhere.
It can be in a subdirectory of your project or in a directory higher than the
libcalc.sh file.
If it is in a different location, change the contents of the script_dir
variable appropriately.

Run the test to make sure it fails.

```console
$ ./libcalc.sh
<!-- include path="../demo/calc/02/output.txt" -->
```

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
<!-- include path="../demo/calc/03/libcalc.sh" -->
```

Of course, renaming functions in libcalc.sh is not required.
Implement your library any way you like.

Write an implementation of the function `calc_add()`.

```bash
<!-- include path="../demo/calc/04/libcalc.sh" -->
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

By the way, you can test in another way as follows:

```console
$ source libcalc.sh
$ calc::run_tests
TAP version 14
1..1
ok - test_add
```

Next, let's add another function to the library.

Add a function that parses arguments and performs calculations so that users
can perform calculations from the shell.

We write the test as we did for the implementation of the calc::add() function.

We decide on calc::app as the function name to implement.
When `calc::app -h` is executed, it outputs the usage.
When an integer is specified, such as `calc::app 2 3`, it performs addition of
the specified values.

```bash
<!-- include path="../demo/calc/05/libcalc.sh" -->
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