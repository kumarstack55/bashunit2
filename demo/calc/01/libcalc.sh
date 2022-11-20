#!/bin/bash

add() {
  : # TODO: implement here
}

test_add() {
  local result

  result=$(add 1 2)

  [[ "$result" -eq 3 ]]
}
