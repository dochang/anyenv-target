setup() {
  PATH="${BATS_TEST_DIRNAME}/bats_modules/bash_shell_mock/bin:$PATH"
  # shellcheck source=libexec/bats_modules/bash_shell_mock/bin/shellmock
  . shellmock
  shellmock_clean

  # shellcheck source=libexec/anyenv-target-update
  . "${BATS_TEST_DIRNAME}/anyenv-target-update"
}

teardown() {
  if [ -z "$TEST_FUNCTION" ]; then
    shellmock_clean
  fi
}

@test "update_git FORCE=1" {
  TARGET_DIR=/path/to/foo
  FORCE=1
  shellmock_expect git --match "-C $TARGET_DIR rev-parse --abbrev-ref @{u}"
  shellmock_expect git --match "-C $TARGET_DIR pull --force --ff --autostash"
  run update_git
  shellmock_verify
  test "$status" = "0"
  test "${#capture[@]}" = 2
}

@test "update_git FORCE=" {
  TARGET_DIR=/path/to/foo
  FORCE=
  shellmock_expect git --match "-C $TARGET_DIR rev-parse --abbrev-ref @{u}"
  shellmock_expect git --match "-C $TARGET_DIR pull --force --ff-only"
  run update_git
  shellmock_verify
  test "$status" = "0"
  test "${#capture[@]}" = 2
}

@test "update_git no tracking branch" {
  TARGET_DIR=/path/to/foo
  FORCE=1
  shellmock_expect git --match "-C $TARGET_DIR rev-parse --abbrev-ref @{u}" --status 1
  shellmock_expect git --match "-C $TARGET_DIR pull --force --ff --autostash"
  run update_git
  shellmock_verify
  test "$status" = "0"
  test "${#capture[@]}" = 1
}
