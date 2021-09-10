#!/bin/sh

src_dir="$1"
dst_dir="$2"

git clone https://github.com/capitalone/bash_shell_mock.git "$src_dir"
cd "$src_dir" || exit
git checkout "$(git describe --tags "$(git rev-list --tags --max-count=1)")"
# https://gist.github.com/rponte/fdc0724dd984088606b0
./install.sh "$dst_dir"
