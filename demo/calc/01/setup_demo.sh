#!/bin/bash
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$script_dir" || exit 1
cp -afv ../../bashunit2.sh ./bashunit2.sh
