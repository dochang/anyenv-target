setup() {
  PATH="${BATS_TEST_DIRNAME}/bats_modules/bash_shell_mock/bin:$PATH"
  # shellcheck source=libexec/bats_modules/bash_shell_mock/bin/shellmock
  . shellmock
  shellmock_clean

  # shellcheck source=libexec/anyenv-target-install
  . "${BATS_TEST_DIRNAME}/anyenv-target-install"
}

teardown() {
  if [ -z "$TEST_FUNCTION" ]; then
    shellmock_clean
  fi
}

@test "fetch_git GIT_REF=foo" {
  GIT_REF=foo
  GIT_URL=https://github.com/anyenv/anyenv.git
  BUILD_DIR=/path/to/anyenv
  shellmock_expect git --match "clone --branch $GIT_REF $GIT_URL $BUILD_DIR"
  run fetch_git
  test "$status" = "0"
}

@test "fetch_git GIT_REF=" {
  GIT_REF=
  GIT_URL=https://github.com/anyenv/anyenv.git
  BUILD_DIR=/path/to/anyenv
  shellmock_expect git --match "clone $GIT_URL $BUILD_DIR"
  run fetch_git
  test "$status" = "0"
}

@test "install_from_git INSTALL_TYPE=skip" {
  INSTALL_TYPE=skip
  VERBOSE=
  ENV=anyenv
  PLUGIN=anyenv
  GIT_REF=
  GIT_URL=https://github.com/anyenv/anyenv.git
  BUILD_ROOT=/path/to
  BUILD_DIR="$BUILD_ROOT/anyenv"
  TARGET_DIR="/target/dir"
  shellmock_expect foo --match "1"
  foo 1
  # We have to call `foo` here because `shellmock_expect` does not create
  # `shellmock.out` if its commands are not invoked, that will cause
  # `shellmock_verify` fails.
  shellmock_expect mktemp --match "-d" --output "$BUILD_ROOT"
  shellmock_expect git --match "clone $GIT_URL $BUILD_DIR"
  shellmock_expect mkdir --match "-p $(dirname "$TARGET_DIR")"
  shellmock_expect mv --match "$BUILD_DIR $TARGET_DIR"
  shellmock_expect rm --match "-rf $BUILD_ROOT"
  run install_from_git
  shellmock_verify
  test "$status" = "0"
  test "$output" = ""
  # shellcheck disable=SC2154
  test "${#capture[@]}" = "1"
}

@test "install_from_git INSTALL_TYPE=install" {
  INSTALL_TYPE=install
  VERBOSE=
  ENV=anyenv
  PLUGIN=anyenv
  GIT_REF=
  GIT_URL=https://github.com/anyenv/anyenv.git
  BUILD_ROOT=/path/to
  BUILD_DIR="$BUILD_ROOT/anyenv"
  TARGET_DIR="/target/dir"
  shellmock_expect mktemp --match "-d" --output "$BUILD_ROOT"
  shellmock_expect git --match "clone $GIT_URL $BUILD_DIR"
  shellmock_expect mkdir --match "-p $(dirname "$TARGET_DIR")"
  shellmock_expect mv --match "$BUILD_DIR $TARGET_DIR"
  shellmock_expect rm --match "-rf $BUILD_ROOT"
  run install_from_git
  shellmock_verify
  test "$status" = "0"
  test "$output" = ""
  # shellcheck disable=SC2154
  test "${#capture[@]}" = "5"
}

@test "install_from_git anyenv/anyenv INSTALL_TYPE=reinstall" {
  INSTALL_TYPE=reinstall
  VERBOSE=
  ENV=anyenv
  PLUGIN=anyenv
  GIT_REF=
  GIT_URL=https://github.com/anyenv/anyenv.git
  BUILD_ROOT=/path/to
  BUILD_DIR="$BUILD_ROOT/anyenv"
  TARGET_DIR="/target/dir"
  shellmock_expect mktemp --match "-d" --output "$BUILD_ROOT"
  shellmock_expect git --match "clone $GIT_URL $BUILD_DIR"
  shellmock_expect mv --match "$TARGET_DIR/versions $BUILD_DIR/versions"
  shellmock_expect mv --match "$TARGET_DIR/version $BUILD_DIR/version"
  shellmock_expect mv --match "$TARGET_DIR ${TARGET_DIR}.prev"
  shellmock_expect mkdir --match "-p $(dirname "$TARGET_DIR")"
  shellmock_expect mv --match "$BUILD_DIR $TARGET_DIR"
  shellmock_expect rm --match "-rf $BUILD_ROOT"
  run install_from_git
  shellmock_verify
  test "$status" = "0"
  test "$output" = ""
  # shellcheck disable=SC2154
  test "${#capture[@]}" = "8"
}

@test "install_from_git anyenv/anyenv-update INSTALL_TYPE=reinstall" {
  INSTALL_TYPE=reinstall
  VERBOSE=
  ENV=anyenv
  PLUGIN=anyenv-git
  GIT_REF=
  GIT_URL=https://github.com/znz/anyenv-update.git
  BUILD_ROOT=/path/to
  BUILD_DIR="$BUILD_ROOT/anyenv"
  TARGET_DIR="/target/dir"
  shellmock_expect mktemp --match "-d" --output "$BUILD_ROOT"
  shellmock_expect git --match "clone $GIT_URL $BUILD_DIR"
  shellmock_expect rm --match "-rf $TARGET_DIR"
  shellmock_expect mkdir --match "-p $(dirname "$TARGET_DIR")"
  shellmock_expect mv --match "$BUILD_DIR $TARGET_DIR"
  shellmock_expect rm --match "-rf $BUILD_ROOT"
  run install_from_git
  shellmock_verify
  test "$status" = "0"
  test "$output" = ""
  # shellcheck disable=SC2154
  test "${#capture[@]}" = "6"
}
