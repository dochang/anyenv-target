#!/bin/sh

root_dir="$(readlink -f "$(dirname "$(dirname "$0")")")"

STOW_TARGET="${STOW_TARGET:-${root_dir}/.stow}"
export STOW_TARGET
STOW_DIR="${STOW_DIR:-${STOW_TARGET}/stow}"
export STOW_DIR
STOW_SRC="${STOW_SRC:-${STOW_TARGET}/src}"
export STOW_SRC

test() {
  PATH="${STOW_TARGET}/bin:$PATH"

  mkdir -p "${STOW_TARGET}"

  ./scripts/install-shellmock.sh "${STOW_SRC}/shellmock" "${STOW_DIR}/shellmock"

  stow --verbose --dir="${STOW_DIR}" --target="${STOW_TARGET}" shellmock

  bats lib libexec test
  kcov --include-path=. coverage bats lib libexec test
}

test
