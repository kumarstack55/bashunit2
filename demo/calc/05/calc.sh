#!/bin/bash

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck source=./libcalc.sh
source "$script_dir/libcalc.sh"

calc::app "$@"
