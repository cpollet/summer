#!/usr/bin/env bash
SCRIPTPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-"$0"}" )" &> /dev/null && pwd )

source "$SCRIPTPATH/env.sh"
env.assert_cmd sed
env.assert_cmd tr
env.assert_cmd cut

string.length() {
  echo -n "${#1}"
}

string.ltrim() {
  echo -n "$1" | sed -e 's/^[[:space:]]*//'
}

string.rtrim() {
  echo -n "$1" | sed -e 's/[[:space:]]*$//'
}

string.trim() {
  string.ltrim "$(string.rtrim "$1")"
}

string.ucase() {
  echo -n "$1" | tr '[a-z]' '[A-Z]'
}

string.lcase() {
  echo -n "$1" | tr '[A-Z]' '[a-z]'
}

string.replace() {
  echo -n "${1//${2}/${3}}"
}

string.repeat() {
  if [ "$1" -gt 0 ]; then
    for i in {1..$1}; do echo -n "$2"; done
  fi
}

string.field() {
  echo -n "$1" | cut -d "$2" -f "$3"
}

string.nvl() {
  [ -n "$1" ] && echo "$1" || echo "$2"
}