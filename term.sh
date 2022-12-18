#!/usr/bin/env bash
SCRIPTPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-"$0"}" )" &> /dev/null && pwd )


term.fgcolor8() {
  local prefix="3" # normal
  if [ $# -ge 2 ] && [ "true" = "$2" ]; then
    prefix="9"     # bright
  fi

  local option=""
  if [ $# -ge 3 ] && [ "+" = "$3" ]; then
    option=";1"    # bold
  elif [ $# -ge 3 ] && [ "-" = "$3" ]; then
    prefix=";2"    # feint
  fi

  echo "\e[${prefix}$1${option}m"
}

term.bgcolor8() {
  local prefix="4" # normal
  if [ $# -ge 2 ] && [ "true" = "$2" ]; then
    prefix="10"    # bright
  fi

  echo "\e[${prefix}$1m"
}

term.reset() {
  echo "\e[0m"
}

term.underline() {
  echo "\e[4m"
}

term.blink() {
  echo "\e[5m"
}

term.uncolor() {
  echo -en "$1" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"
}

COLOR_BLACK=0
COLOR_RED=1
COLOR_GREEN=2
COLOR_YELLOW=3
COLOR_BLUE=4
COLOR_MAGENTA=5
COLOR_CYAN=6
COLOR_WHITE=7

TERM_RESET="$(term.reset)"
UNDERLINE="$(term.underline)"

BLINK="$(term.blink)"
FG_BLACK="$(term.fgcolor8 "$COLOR_BLACK")"
FG_RED="$(term.fgcolor8 "$COLOR_RED")"
FG_GREEN="$(term.fgcolor8 "$COLOR_GREEN")"
FG_YELLOW="$(term.fgcolor8 "$COLOR_YELLOW")"
FG_BLUE="$(term.fgcolor8 "$COLOR_BLUE")"
FG_MAGENTA="$(term.fgcolor8 "$COLOR_MAGENTA")"
FG_CYAN="$(term.fgcolor8 "$COLOR_CYAN")"
FG_WHITE="$(term.fgcolor8 "$COLOR_WHITE")"

BG_BLACK="$(term.bgcolor8 "$COLOR_BLACK")"
BG_RED="$(term.bgcolor8 "$COLOR_RED")"
BG_GREEN="$(term.bgcolor8 "$COLOR_GREEN")"
BG_YELLOW="$(term.bgcolor8 "$COLOR_YELLOW")"
BG_BLUE="$(term.bgcolor8 "$COLOR_BLUE")"
BG_MAGENTA="$(term.bgcolor8 "$COLOR_MAGENTA")"
BG_CYAN="$(term.bgcolor8 "$COLOR_CYAN")"
BG_WHITE="$(term.bgcolor8 "$COLOR_WHITE")"