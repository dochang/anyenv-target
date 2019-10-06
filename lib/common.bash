#!/usr/bin/env bash

parse_options() {
  OPTIONS=()
  ARGUMENTS=()
  local arg option index

  for arg in "$@"; do
    if [ "${arg:0:1}" = "-" ]; then
      if [ "${arg:1:1}" = "-" ]; then
        OPTIONS[${#OPTIONS[*]}]="${arg:2}"
      else
        index=1
        while option="${arg:$index:1}"; do
          [ -n "$option" ] || break
          OPTIONS[${#OPTIONS[*]}]="$option"
          index=$((index + 1))
        done
      fi
    else
      ARGUMENTS[${#ARGUMENTS[*]}]="$arg"
    fi
  done
}

set_env_and_plugin() {
  local target
  target="$1"

  case "$target" in
  /*-*)
    PLUGIN="${target#/}"
    ENV="${PLUGIN%%-*}"
    ;;
  /*)
    PLUGIN="${target#/}"
    ENV="${PLUGIN}"
    ;;
  */)
    ENV="${target%/}"
    PLUGIN="${ENV}"
    ;;
  */*)
    ENV="${target%/*}"
    PLUGIN="${target#*/}"
    ;;
  *-*)
    ENV="${target%%-*}"
    PLUGIN="${target}"
    ;;
  *)
    ENV="${target}"
    PLUGIN="${target}"
    ;;
  esac
}

set_target_dir() {
  if [ -z "$ANYENV_ROOT" ]; then
    echo "ANYENV_ROOT not defined" >&2
    return 1
  fi

  if [ "$ENV" = anyenv ]; then
    ENV_DIR="$ANYENV_ROOT"
  else
    ENV_DIR="${ANYENV_ROOT}/envs/${ENV}"
  fi

  if [ "$ENV" = "$PLUGIN" ]; then
    TARGET_DIR="$ENV_DIR"
  else
    TARGET_DIR="${ENV_DIR}/plugins/${PLUGIN}"
  fi

  export TARGET_DIR
}

target_name() {
  if [ "$ENV" = "$PLUGIN" ]; then
    echo "$ENV"
  else
    echo "${ENV}/${PLUGIN}"
  fi
}

print_horizontal_separator() {
  if [ -n "$VERBOSE" ]; then
    printf '%s\n' "$ANYENV_TARGET_SEPARATOR"
  fi
}
