#!/usr/bin/env bash

source env.sh
env.assert_cmd bc

math.eval() {
	echo "$1" | bc
}