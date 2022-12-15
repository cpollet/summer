#!/usr/bin/env bash
SCRIPTPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-"$0"}" )" &> /dev/null && pwd )

source "$SCRIPTPATH/env.sh"
env.assert_cmd uuidgen

source "$SCRIPTPATH/string.sh"

random.uuid() {
  string.lcase "$(uuidgen)"
}