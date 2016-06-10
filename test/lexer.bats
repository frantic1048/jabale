#!/usr/bin/env bats

LEXER="./JabaleLexer"

@test "should found 23" {
  result=$($LEXER <<<"tatee 23 yooo")
  [ "$result" = '23' ]
}
