#!/bin/bash

_usage() {
  while IFS='' read -r line; do
    echo "$line" >&2
  done <<__USAGE__
Usage: generate.sh [OPTION]...

  -i infile     Template input file.
  -h            display this help and exit.
__USAGE__
}

parse_infile() {
  local infile="$1" re path
  local line line2

  re='<!--[[:space:]]+include[[:space:]]+path=\"([^\"]+)\"[[:space:]]+-->'

  while IFS='' read -r line; do
    if [[ $line =~ $re ]]; then
      path="${BASH_REMATCH[1]}"
      while IFS='' read -r line2; do
        echo "$line2"
      done <"$path"
    else
      echo "$line"
    fi
  done <"$infile"
}

main() {
  local infile='' opt

  while getopts :hi:o: opt; do
    case "$opt" in
      i) infile="$OPTARG";;
      h) _usage; return 1;;
      *) _usage; return 1;;
    esac
  done
  shift $((OPTIND-1))

  if [ ! "$infile" ]; then
    _usage
    return 1
  fi

  parse_infile "$infile"
}

main "$@"
