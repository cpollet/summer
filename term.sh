#!/usr/bin/env bash
SCRIPTPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-"$0"}" )" &> /dev/null && pwd )

term.uncolor() {
  echo -en "$1" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
}
