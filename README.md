# anyenv-target

[![Build Status](https://cloud.drone.io/api/badges/dochang/anyenv-target/status.svg)](https://cloud.drone.io/dochang/anyenv-target)
[![codecov](https://codecov.io/gh/dochang/anyenv-target/branch/master/graph/badge.svg)](https://codecov.io/gh/dochang/anyenv-target)
[![License](https://img.shields.io/badge/license-MIT-green)](https://dochang.mit-license.org/)
<!-- markdown-link-check-disable -->
[![Say Thanks!](https://img.shields.io/badge/say-thanks-green)](https://saythanks.io/to/dochang)
<!--
See the following issues for details.

<https://github.com/BlitzKraft/saythanks.io/issues/60>
<https://github.com/BlitzKraft/saythanks.io/issues/103>
-->
<!-- markdown-link-check-enable -->

`anyenv-target` is an [anyenv] plugin that provides `anyenv target` command to
install/update/uninstall envs or plugins as targets.

This project is a successor of [anyenv/anyenv#48].

[anyenv]: https://github.com/anyenv/anyenv
[anyenv/anyenv#48]: https://github.com/anyenv/anyenv/pull/48

## Installation

```
mkdir -p $(anyenv root)/plugins
git clone https://github.com/dochang/anyenv-target.git $(anyenv root)/plugins/anyenv-target
```

## Usage

```
$ anyenv target install rbenv
$ anyenv target install rbenv@master
$ anyenv target install rbenv=https://github.com/rbenv/rbenv.git
$ anyenv target install rbenv=https://github.com/rbenv/rbenv.git@master
$ anyenv target install rbenv-each
$ anyenv target install rbenv/rbenv-each
$ anyenv target install rbenv/ruby-build
$ anyenv target install rbenv/ruby-build@master
$ anyenv target install rbenv/ruby-build=https://github.com/rbenv/ruby-build.git
$ anyenv target install rbenv/ruby-build=https://github.com/rbenv/ruby-build.git@master
$ anyenv target install rbenv rbenv-each rbenv/ruby-build
$ anyenv target update pyenv rbenv-each rbenv/ruby-build
$ anyenv target uninstall pyenv rbenv-each rbenv/ruby-build
```

## Target

A target can be an env or plugin. The basic form of target is `ENV/PLUGIN`,
which means "PLUGIN of ENV". There is also a special case: `ENV/ENV`, which
means ENV itself. For instance, `rbenv/rbenv` means `rbenv`, **NOT** a plugin
named `rbenv`.

You can also use the short form for a target by the following rules:

TARGET (short form) | TARGET (full form) | ENV     | PLUGIN
------------------- | ------------------ | ------- | -----------
foo/bar             | foo/bar            | foo     | bar
foo/foo-bar         | foo/foo-bar        | foo     | foo-bar
foo/baz-bar         | foo/baz-bar        | foo     | baz-bar
foo/foo             | foo/foo            | foo     | foo
foo                 | foo/foo            | foo     | foo
foo-bar             | foo/foo-bar        | foo     | foo-bar
foo-bar-baz         | foo/foo-bar-baz    | foo     | foo-bar-baz
foo/                | foo/foo            | foo     | foo
/bar                | bar/bar            | bar     | bar
/foo-bar            | foo/foo-bar        | foo     | foo-bar
foo-bar/            | foo-bar/foo-bar    | foo-bar | foo-bar

For example:

TARGET (short form) | TARGET (full form) | ENV   | PLUGIN
------------------- | ------------------ | ----- | ----------
rbenv/rbenv-each    | rbenv/rbenv-each   | rbenv | rbenv-each
rbenv               | rbenv/rbenv        | rbenv | rbenv
rbenv-each          | rbenv/rbenv-each   | rbenv | rbenv-each
rbenv/ruby-build    | rbenv/ruby-build   | rbenv | ruby-build
ruby-build          | ruby/ruby-build    | ruby  | ruby-build

Remember, `rbenv/rbenv` means the env `rbenv`, **NOT** a plugin named `rbenv`.

### Install Target

When installing a target, anyenv will check the source url in the file
`SOURCE_DIR/ENV/PLUGIN`. Anyenv will try `SOURCE_DIR` in this order:

  - `$XDG_CONFIG_HOME/anyenv/sources` (default: `$HOME/.config/anyenv/sources`)
  - `$ANYENV_ROOT/share/anyenv/sources`

The source is the git url downloaded by anyenv. If you want to use a branch
other than the default branch, put

```
<GIT_URL> <GIT_REF>
```

into the source file.

If the source file does not exist, anyenv will try
`https://github.com/ENV/PLUGIN.git` with the default branch.

You can also override the url and default branch in the argument, using
`TARGET[=URL][@REF]`. For example:

```
$ anyenv target install rbenv@master
$ anyenv target install rbenv=https://github.com/rbenv/rbenv.git
$ anyenv target install rbenv=https://github.com/rbenv/rbenv.git@master
$ anyenv target install rbenv/ruby-build@master
$ anyenv target install rbenv/ruby-build=https://github.com/rbenv/ruby-build.git
$ anyenv target install rbenv/ruby-build=https://github.com/rbenv/ruby-build.git@master
```

## License

[MIT](https://dochang.mit-license.org/)
