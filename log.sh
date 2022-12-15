#!/usr/bin/env bash

log_LEVEL=info

log._level() {
	case "$1" in
		trace) echo -n "0"; return ;;
		debug) echo -n "1"; return ;;
		info)  echo -n "2"; return ;;
		warn)  echo -n "3"; return ;;
		error) echo -n "4"; return ;;
		*)     echo "Unsupported level $log_LEVEL"; exit ;;
	esac
}

log._print() {
	[ $(log._level "$log_LEVEL") -le $1 ] && echo -e "$2" >&2
}

log.enabled() {
	[ $(log._level "$log_LEVEL") -le $(log._level "$1") ]
}

log.trace() {
	log._print 0 "$1"
}

log.debug() {
	log._print 1 "$1"
}

log.info() {
	log._print 2 "$1"
}

log.warn() {
	log._print 3 "$1"
}

log.error() {
	log._print 4 "$1"
}