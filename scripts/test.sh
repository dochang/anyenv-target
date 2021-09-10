#!/bin/sh

STOW_TARGET="${STOW_TARGET:-/opt/stow}"
export STOW_TARGET
STOW_DIR="${STOW_DIR:-${STOW_TARGET}/stow}"
export STOW_DIR
STOW_SRC="${STOW_SRC:-${STOW_TARGET}/src}"
export STOW_SRC

test_on_drone() {
  PATH="${STOW_TARGET}/bin:$PATH"

  mkdir -p "${STOW_TARGET}"

  apt-get update
  apt-get --yes install stow

  ./scripts/install-bats.sh "${STOW_SRC}/bats" "${STOW_DIR}/bats"
  ./scripts/install-shellmock.sh "${STOW_SRC}/shellmock" "${STOW_DIR}/shellmock"
  ./scripts/install-kcov.sh "${STOW_SRC}/kcov" "${STOW_DIR}/kcov"

  stow --verbose --dir="${STOW_DIR}" --target="${STOW_TARGET}" bats shellmock kcov

  # Bash 4.4+ disallow that kcov sets `PS4` when running as root.  Also,
  # bats does not work with `kcov --bash-method=DEBUG`.  We have to run
  # test as a non-root user.
  #
  # https://github.com/SimonKagstrom/kcov/issues/213#issuecomment-378249216
  # https://github.com/SimonKagstrom/kcov/issues/234#issuecomment-363013297
  # https://security-tracker.debian.org/tracker/CVE-2016-7543
  useradd testuser
  TEST_TMPDIR="$(mktemp -d)"
  export TEST_TMPDIR
  chown -R testuser . "$TEST_TMPDIR"
  su --whitelist-environment=TEST_TMPDIR --command="bats lib libexec test" testuser
  su --whitelist-environment=TEST_TMPDIR --command="kcov --include-path=. coverage bats lib libexec test" testuser
  chown -R root .
}

test_on_github_actions() {
  GUIX_PACK_ROOT="${GUIX_PACK_ROOT:-/opt/guix}"
  export GUIX_PACK_ROOT
  PATH="${STOW_TARGET}/bin:${GUIX_PACK_ROOT}/bin:$PATH"

  mkdir -p "${STOW_TARGET}"

  ./scripts/install-bats.sh "${STOW_SRC}/bats" "${STOW_DIR}/bats"
  ./scripts/install-shellmock.sh "${STOW_SRC}/shellmock" "${STOW_DIR}/shellmock"

  stow --verbose --dir="${STOW_DIR}" --target="${STOW_TARGET}" bats shellmock

  bats lib libexec test
  kcov --include-path=. coverage bats lib libexec test
}

if [ "$DRONE" = true ]; then
  test_on_drone
elif [ "$GITHUB_ACTIONS" = true ]; then
  test_on_github_actions
fi
