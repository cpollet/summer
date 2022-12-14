#!/usr/bin/env bash

source env.sh
env.assert_cmd curl
env.assert_cmd jq
env.assert_cmd base64

source string.sh

http_DEBUG=false

http._debug() {
	[ "$http_DEBUG" = "true" ] && echo -n "-v"
}

http._curl() {
	local url="$1"; shift
	curl $(http._debug) "$url" --silent --write-out '\n{"code":%{response_code},"content_type":"%{content_type}"}' "$@"
}

http._format_response() {
	local http_data="$(tail -n1 <<< "$1")"
	local content_type="$(echo "$http_data" | jq --raw-output '.content_type | split(";") | .[0] | ascii_downcase')"
	
	if [ "${content_type:-}" = "application/json" ]; then
		echo "$1" | jq --slurp '{ payload: .[0], http: .[1] }'
	else
		local payload="$(sed '$ d' <<< "$1")"
		echo "$http_data" | jq --arg payload "$payload" '{ payload: $payload, http: . }'
	fi
}

http.basic_auth_header() {
	echo "Authorization: Basic $(echo -n "$1" | base64)"
}

http.get() {
	url="$1"; shift
	http._format_response "$(http._curl "$url" "$@")"
}

http.post() {
	local url="$1"; shift
	local content_type="$1"; shift
	local payload="$1"; shift

	http._format_response "$(http._curl "$url" \
		--header "Content-Type: $content_type" \
		--data "$payload" \
		"$@")"
}

http.post_json() {
	http.post "$1" "application/json" "$2"
}

http.put() {
	local url="$1"; shift
	local content_type="$1"; shift
	local payload="$1"; shift

	http._format_response "$(http._curl "$url" -X PUT \
		--header "Content-Type: $content_type" \
		--data "$payload" \
		"$@")"
}

http.put_json() {
	http.put "$1" "application/json" "$2"
}