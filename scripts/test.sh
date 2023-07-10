#!/bin/sh

STOW_TARGET="${STOW_TARGET:-/opt/stow}"
export STOW_TARGET
STOW_DIR="${STOW_DIR:-${STOW_TARGET}/stow}"
export STOW_DIR
STOW_SRC="${STOW_SRC:-${STOW_TARGET}/src}"
export STOW_SRC

test_on_github_actions() {
  GUIX_PACK_ROOT="${GUIX_PACK_ROOT:-/opt/guix}"
  export GUIX_PACK_ROOT
  PATH="${STOW_TARGET}/bin:${GUIX_PACK_ROOT}/bin:$PATH"

  mkdir -p "${STOW_TARGET}"

  ./scripts/install-shellmock.sh "${STOW_SRC}/shellmock" "${STOW_DIR}/shellmock"

  stow --verbose --dir="${STOW_DIR}" --target="${STOW_TARGET}" shellmock

  bats lib libexec test
  kcov --include-path=. coverage bats lib libexec test
}

if [ "$GITHUB_ACTIONS" = true ]; then
  test_on_github_actions
fi
