# bashunit2

bashunit2 is a framework for TAP compliant testing.

![GitHub Actions](https://github.com/kumarstack55/bashunit2/actions/workflows/ci.yml/badge.svg)

## Features

* This is pure Bash code. There is no framework-specific syntax.
* There is only one file that you need to depend on for testing: `bashunit2.sh`.
* You can include your test codes in your library.

## Requirements

* Bash 4.4+

## Quickstart

### Implement your first test

In this introduction, we will implement a library that does the calculations.
Let us name the library file `libcalc.sh`.

As a calculation, implement a function that performs addition.
Let us name the function that performs the addition `calc_add`.

We want to make sure calc_add is properly implemented.
bashunit2 recognizes a function as a test function if it contains `test_`
at the beginning of the function name or `::test_` in the middle of the
function name.
Let us name our function for testing `test_calc_add`.

Let's write the test first.

The following file shows the code with a few lines added to the previous
file.

```bash
<!-- include path="../demo/calc/01/libcalc.sh" -->
```

The function `test_calc_add` executes `calc_add`, determines from the result
whether the addition is correct, and returns the result to the caller of the
test function.

### Add code to run tests

We have defined two functions `calc_add` and `test_calc_add`.
However, we currently have no way to run the tests.
Let's add some code to make it possible to run the tests in bashunit2.

The following file shows the code with a few lines added to the previous
file.

```bash
<!-- include path="../demo/calc/02/libcalc.sh" -->
```

This code can be executed in two ways: first, it can be executed as
`./libcalc.sh`. The second is as follows: `source ./libcalc.sh`.

Either way, the `script_dir` variable will be assigned to the directory
where `libcalc.sh` is located.

To use bashunit2, only one file, `bashunit2.sh`, is required.

This example assumes that `libcalc.sh` and `bashunit2.sh` are in the same
directory.
However, there is no need for them to be in the same directory.
You can place bashunit2.sh anywhere you wish, according to the policies of
your project.
If you choose to place it in a different directory, set the value of the
script_dir variable to an appropriate value.

### Run the test and confirm that it fails

Now you can run the test.
`test_calc_add` is already implemented.
`calc_add` is not implemented.

Therefore, the expected behavior is that the test can be executed and the
test will fail.

Let's run the test.

The following log is the result of the run.

```console
$ ./libcalc.sh
<!-- include path="../demo/calc/02/output.txt" -->
```

bashunit2 outputs test results in TAP format.
For more information about TAP, please click
[here](https://testanything.org/).

In the preceding output, we see the following:

* The number of tests is one from 1 to 1.
* The test for `test_calc_add` failed, as the result was printed as `not ok`.

### Optional: Rename the functions

By the way, bashunit2's function naming conventions are based on the
[Shell Style Guide](https://google.github.io/styleguide/shellguide.html).

bashunit2 can run library tests using the Shell Style Guide naming
conventions.

The `bashunit2::run_tests` that runs the tests is the function name.
`bashunit2` represents the library name.
bashunit2 will automatically discover the test functions.
bashunit2 recognizes test functions with `test_` at the beginning of the function name or with `::test_` in the middle of the function name.

For this introduction, let's rename the function name of `libcalc.sh` as
well, as follows:

```bash
<!-- include path="../demo/calc/03/libcalc.sh" -->
```

Of course, renaming functions in libcalc.sh is not required.
Implement your library any way you like.

From here on, this introduction will use the renamed code as an example.

### Implement the code and run tests

Let's write an implementation of the function `calc::add()`.

```bash
<!-- include path="../demo/calc/04/libcalc.sh" -->
```

Run the test again to verify that the test passes.

```console
$ ./libcalc.sh
<!-- include path="../demo/calc/04/output.txt" -->
```

Congratulations!
You've implemented `calc::add` and it passes all your tests!

### Another way to run the test

By the way, you can test in another way as follows:

```console
$ source ./libcalc.sh
$ calc::run_tests
<!-- include path="../demo/calc/04/output2.txt" -->
```

If you want to test with interactive operations or override some functions,
you may prefer this method.

### Implement the application 1

We have implemented `calc::add`.
Let's define a new function that calls `calc::add` so we can perform addition
from the shell. Let us name the function `calc::app`.

Let us assume that the function has the following main functions:

* `calc::app -h` will output help and exit abnormally.
* Output help and exit abnormally if an unknown option is given, like `calc::app -x`.
* Add up integers given as `calc::app 2 3`.
* If an integer number other than 2 is given, like `calc::app 2 3 4`, help is printed and an abnormal exit is returned.

The following file is the code that implements the tests:

```bash
<!-- include path="../demo/calc/05/libcalc.sh" -->
```

We have implemented the test.
We have not implemented `calc::app`.
Therefore, when we run the test, we expect it to fail.

The following file is the result of running the test:

```bash
<!-- include path="../demo/calc/05/output.txt" -->
```

As expected, the test failed to run.

### Add a helper function to learn about failed evaluations

There are multiple evaluation functions in the test function.
At this time, it is difficult to know where the line where the test failed.

In such a case, the recommended solution is to define a wrapper function
that executes the exit.
The wrapper function should be named `calc::_die`.
The leading underscore in `_die` is to make it easier for users to
understand the meaning of calling it only in the library `calc`.

The following file shows the code with `calc::_die` added and the exit of
each test function replaced with `calc::_die`.

```bash
<!-- include path="../demo/calc/06/libcalc.sh" -->
```

After executing this code, you will know which evaluation failed.

The following log shows the results of the test run.

```console
$ ./libcalc.sh
<!-- include path="../demo/calc/06/output.txt" -->
```

You can see the lines where the evaluation failed.

### Implement the application 2

Implement parsing of arguments, etc., and make sure all tests can be run.

The following file is the code that makes all tests succeed:

```bash
<!-- include path="../demo/calc/07/libcalc.sh" -->
```

The following logs show the results of the test run:

```console
$ ./libcalc.sh
<!-- include path="../demo/calc/07/output.txt" -->
```

`./libcalc.sh: illegal option -- x` is probably what getopts output to
stderr.

### Capture standard output, standard error output, and exit status

bashunit2 has the ability to run commands and collect standard output,
standard error output, and exit status.

Be sure to add evaluation to your existing tests to verify that the
`illegal option` is output.

The following function is rewritten code in `bashunit2::run`:

```bash
calc::test_app_prints_usage_when_unknown_option_exists() {
  local exit_status stdout stderr

  bashunit2::run calc::app -x
  exit_status=$(bashunit2::print_run_last_exit_status)
  stdout=$(bashunit2::print_run_last_stdout)
  stderr=$(bashunit2::print_run_last_stderr)

  [[ $exit_status -eq 1 ]] || calc::_die
  [[ "$stdout" =~ 'Usage:' ]] || calc::_die
  [[ "$stderr" =~ 'illegal option' ]] || calc::_die
}
```

The following log shows the results of the test run:

```console
$ ./libcalc.sh
<!-- include path="../demo/calc/08/output.txt" -->
```

### Implement the application 3

Finally, create the code to run `calc::app`.
Let us name the file `calc.sh`.

The next file is `calc.sh`:

```bash
<!-- include path="../demo/calc/08/calc.sh" -->
```

The script_dir variable is assigned to the calc.sh directory.

libcalc.sh in the same directory is loaded.

Then `calc::app` is executed.

Now, let's run `./calc.sh 1 2` is executed.

```console
$ ./calc.sh 1 2
3
```

Congratulations!

You can now use the tested and quality-assured `libcalc.sh` from `calc.sh`!

## TODO

* Add assert_*()
* Add document for mock

## Similar projects

* [Bats-core](https://github.com/bats-core/bats-core)
* [shUnit2](https://github.com/kward/shunit2)
* [bashunit](https://github.com/djui/bashunit)
* [bashUnit](https://github.com/athena-oss/bashunit)
* [ShellSpec](https://github.com/shellspec/shellspec)
