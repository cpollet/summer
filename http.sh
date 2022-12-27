#!/usr/bin/env bash
SCRIPTPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-"$0"}" )" &> /dev/null && pwd )

source "$SCRIPTPATH/env.sh"
env.assert_cmd curl
env.assert_cmd jq
env.assert_cmd base64

source "$SCRIPTPATH/string.sh"
source "$SCRIPTPATH/log.sh"

http_DEBUG=false
http_SSL_INSECURE=false
http_DUMP_CURL_COMMAND=false

http._debug() {
  if log.enabled trace || [ "$http_DEBUG" = "true" ]; then
    echo -n "--verbose"
  else
    echo -n "--no-verbose"
  fi
}

http._insecure() {
  if [ "$http_SSL_INSECURE" = "true" ]; then
    echo -n "--insecure"
  else
    echo -n "--no-insecure"
  fi
}

http._curl() {
  local verb="$1"; shift
  local url="$1"; shift

  log.debug "-> $verb $url"

  if [ "true" = "$http_DUMP_CURL_COMMAND" ]; then
    echo -ne "
curl \"$url\" \\\\
  $(http._debug) \\\\
  $(http._insecure) \\\\
  --silent \\\\
  --write-out '\\\n{\"status\":%{response_code},\"content_type\":\"%{content_type}\"}' \\\\\n" >&2
    for value in "$@"; do
      if [[ "$value" =~ ^[a-zA-Z0-9_-.]+$ ]]; then
        echo -n "$value " >&2
      else
        echo -n "\"$value\" " >&2
      fi
    done
    echo -e "\n" >&2
  fi

  local response="$(http._format_response "$(curl "$url" \
    "$(http._debug)" \
    "$(http._insecure)" \
    --silent \
    --write-out '\n{"status":%{response_code},"content_type":"%{content_type}"}' \
    "$@" \
  )")"

  log.trace "response: START>$response<END"
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
    echo "Authorization: Basic $(echo -n "$1:$2" | base64)"
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
    -X PUT --data "$payload" \
    "$@"
}

http.put_json() {
  local url="$1"; shift
  local payload="$1"; shift
  http.put "$url" "application/json" "$payload" "$@"
}

http.status_successful() {
  [ "$(echo "$1 / 100" | bc)" = "2" ]
}