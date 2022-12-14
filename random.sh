#!/usr/bin/env bash

source env.sh
env.assert_cmd uuidgen

source string.sh

random.uuid() {
	string.lcase "$(uuidgen)"
}