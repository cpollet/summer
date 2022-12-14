#!/usr/bin/env bash

env.assert_cmd() {
	if ! command -v "$1" >/dev/null; then
		echo "The command $1 cound not be found"
		exit 1
	fi
}