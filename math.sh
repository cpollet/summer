#!/usr/bin/env bash
SCRIPTPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-"$0"}" )" &> /dev/null && pwd )

source "$SCRIPTPATH/env.sh"
env.assert_cmd bc

math.eval() {
  echo "$1" | bc
}