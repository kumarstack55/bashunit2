#!/bin/bash

calc_add() {
  : # TODO: implement here
}

test_calc_add() {
  local result

  result=$(calc_add 1 2)

  [[ "$result" -eq 3 ]]
}
