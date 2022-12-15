#!/usr/bin/env bash

source env.sh
env.assert_cmd curl
env.assert_cmd jq
env.assert_cmd base64

source string.sh
source log.sh

http_DEBUG=false

http._debug() {
	log.enabled trace || [ "$http_DEBUG" = "true" ] && echo -n "-v"
}

http._curl() {
	local verb="$1"; shift
	local url="$1"; shift

	log.debug "-> $verb $url"

	local response="$(http._format_response "$(curl $(http._debug) "$url" \
		--silent \
		--write-out '\n{"code":%{response_code},"content_type":"%{content_type}"}' \
		"$@"\
	)")"

	log.enabled debug && log.debug "$(echo "$response" | jq --color-output)"

	echo "$response"
}

http._format_response() {
	local http_data="$(tail -n1 <<< "$1")"
	local content_type="$(echo "$http_data" | jq --raw-output '.content_type | split(";") | .[0] | ascii_downcase')"
	
	if [ "${content_type:-}" = "application/json" ]; then
		echo "$1" | jq --compact-output --slurp '{ payload: .[0], http: .[1] }'
	else
		local payload="$(sed '$ d' <<< "$1")"
		echo "$http_data" | jq --compact-output --arg payload "$payload" '{ payload: $payload, http: . }'
	fi
}

http.basic_auth_header() {
	if [ $# -eq 1 ]; then
		echo "Authorization: Basic $(echo -n "$1" | base64)"
	elif [ $# -eq 2 ]; then
		echo "Authorization: Basic $(echo -n "$1" | base64)"
	else
		echo "Invalid input: expected 1 or 2 params, got $#" >&2
	fi
}

http.get() {
	local url="$1"; shift
	http._curl GET "$url" "$@"
}

http.post() {
	local url="$1"; shift
	local content_type="$1"; shift
	local payload="$1"; shift

	http._curl POST "$url" \
		--header "Content-Type: $content_type" \
		--data "$payload" \
		"$@"
}

http.post_json() {
	local url="$1"; shift
	local payload="$1"; shift
	http.post "$url" "application/json" "$payload" "$@"
}

http.put() {
	local url="$1"; shift
	local content_type="$1"; shift
	local payload="$1"; shift

	http._curl PUT "$url" \
		--header "Content-Type: $content_type" \
		--data "$payload" \
		"$@"
}

http.put_json() {
	local url="$1"; shift
	local payload="$1"; shift
	http.put "$url" "application/json" "$payload" "$@"
}