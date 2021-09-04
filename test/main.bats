@test "main" {
  TESTDIR="$(mktemp -d -p "${TEST_TMPDIR:-${BATS_TMPDIR}}")"

  export ANYENV_ROOT="${TESTDIR}/anyenv"
  export ANYENV_DEFINITION_ROOT="${TESTDIR}/anyenv-install"

  git clone https://github.com/anyenv/anyenv.git "$ANYENV_ROOT"
  PATH="${ANYENV_ROOT}/bin:$PATH"
  anyenv install --force-init
  mkdir -p "${ANYENV_ROOT}/plugins"
  ln -s "$(dirname "${BATS_TEST_DIRNAME}")" "${ANYENV_ROOT}/plugins/anyenv-target"

  anyenv target install --force anyenv-git
  test -d "${ANYENV_ROOT}/plugins/anyenv-git"

  anyenv target install --force rbenv
  test -d "${ANYENV_ROOT}/envs/rbenv"

  anyenv target install --force rbenv/ruby-build
  test -d "${ANYENV_ROOT}/envs/rbenv/plugins/ruby-build"

  anyenv target install --force rbenv-each
  test -d "${ANYENV_ROOT}/envs/rbenv/plugins/rbenv-each"

  anyenv target uninstall --force rbenv-each
  test ! -d "${ANYENV_ROOT}/envs/rbenv/plugins/rbenv-each"

  anyenv target uninstall --force rbenv/ruby-build
  test ! -d "${ANYENV_ROOT}/envs/rbenv/plugins/ruby-build"

  anyenv target uninstall --force rbenv
  test ! -d "${ANYENV_ROOT}/envs/rbenv"

  anyenv target uninstall --force anyenv-git
  test ! -d "${ANYENV_ROOT}/plugins/anyenv-git"
}
