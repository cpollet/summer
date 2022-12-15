#!/usr/bin/env bash
SCRIPTPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-"$0"}" )" &> /dev/null && pwd )

env.assert_cmd() {
  if ! command -v "$1" >/dev/null; then
    echo "The command $1 cound not be found"
    exit 1
  fi
}