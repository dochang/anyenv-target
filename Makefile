lint-deps:
	gem install rufo
	npm install -g eclint

lint:
	rufo --check Brewfile
	{ shfmt -f . ; find . -name '*.bats' ; } | grep -v -e bats_modules/ -e coverage/ | xargs eclint check
	shfmt -f . | grep -v -e bats_modules/ -e coverage/ | xargs shfmt -d -i 2
	{ shfmt -f . ; find . -name '*.bats' ; } | grep -v -e bats_modules/ -e coverage/ | xargs shellcheck --external-sources
# `shellcheck` does not have a `-r` option.  Use `shfmt` and `find` to find all
# files to check.
#
# https://github.com/koalaman/shellcheck/wiki/Recursiveness

test:
	kcov --include-path=. coverage bats lib libexec test

.PHONY: lint-deps lint test
