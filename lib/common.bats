setup() {
  PATH="${BATS_TEST_DIRNAME}/bats_modules/bash_shell_mock/bin:$PATH"
  # shellcheck source=lib/bats_modules/bash_shell_mock/bin/shellmock
  . shellmock
  shellmock_clean

  # shellcheck source=lib/common.bash
  . "${BATS_TEST_DIRNAME}/common.bash"
}

teardown() {
  if [ -z "$TEST_FUNCTION" ]; then
    shellmock_clean
  fi
}

@test "parse_options" {
  parse_options "--foo=bar" "--baz" "qux"
  foobar_counter=0
  baz_counter=0
  others_counter=0
  for option in "${OPTIONS[@]}"; do
    case "$option" in
    "foo=bar" )
      foobar_counter=$((foobar_counter+1))
      ;;
    "baz" )
      baz_counter=$((baz_counter+1))
      ;;
    * )
      others_counter=$((others_counter+1))
      ;;
    esac
  done
  test "$foobar_counter" -eq 1
  test "$baz_counter" -eq 1
  test "$others_counter" -eq 0
  test "${ARGUMENTS[*]}" = "qux"
}

@test "set_env_and_plugin" {
  set_env_and_plugin foo/bar
  test "$ENV" = foo
  test "$PLUGIN" = bar

  set_env_and_plugin foo/foo-bar
  test "$ENV" = foo
  test "$PLUGIN" = foo-bar

  set_env_and_plugin foo/baz-bar
  test "$ENV" = foo
  test "$PLUGIN" = baz-bar

  set_env_and_plugin foo/foo
  test "$ENV" = foo
  test "$PLUGIN" = foo

  set_env_and_plugin foo
  test "$ENV" = foo
  test "$PLUGIN" = foo

  set_env_and_plugin foo-bar
  test "$ENV" = foo
  test "$PLUGIN" = foo-bar

  set_env_and_plugin foo-bar-baz
  test "$ENV" = foo
  test "$PLUGIN" = foo-bar-baz

  set_env_and_plugin foo/
  test "$ENV" = foo
  test "$PLUGIN" = foo

  set_env_and_plugin /bar
  test "$ENV" = bar
  test "$PLUGIN" = bar

  set_env_and_plugin /foo-bar
  test "$ENV" = foo
  test "$PLUGIN" = foo-bar

  set_env_and_plugin foo-bar/
  test "$ENV" = foo-bar
  test "$PLUGIN" = foo-bar
}

@test "set_target_dir" {
  ANYENV_ROOT='' run set_target_dir
  test "$status" -eq 1
  test "$output" = 'ANYENV_ROOT not defined'

  export ANYENV_ROOT=/path/to/anyenv

  ENV=anyenv
  PLUGIN=anyenv
  set_target_dir
  test "$TARGET_DIR" = "${ANYENV_ROOT}"

  ENV=anyenv
  PLUGIN=anyenv-target
  set_target_dir
  test "$TARGET_DIR" = "${ANYENV_ROOT}/plugins/${PLUGIN}"

  ENV=rbenv
  PLUGIN=rbenv
  set_target_dir
  test "$TARGET_DIR" = "${ANYENV_ROOT}/envs/${ENV}"

  ENV=rbenv
  PLUGIN=ruby-build
  set_target_dir
  test "$TARGET_DIR" = "${ANYENV_ROOT}/envs/${ENV}/plugins/${PLUGIN}"
}

@test "target_name" {
  ENV=rbenv
  PLUGIN=rbenv
  run target_name
  test "$status" -eq 0
  test "$output" = rbenv

  ENV=rbenv
  PLUGIN=ruby-build
  run target_name
  test "$status" -eq 0
  test "$output" = rbenv/ruby-build
}

@test "print_horizontal_separator" {
  ANYENV_TARGET_SEPARATOR=---

  VERBOSE=1
  run print_horizontal_separator
  test "$status" -eq 0
  test "$output" = '---'

  VERBOSE=''
  run print_horizontal_separator
  test "$status" -eq 0
  test "$output" = ''
}
