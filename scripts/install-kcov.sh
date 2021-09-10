#!/bin/sh

src_dir="$1"
dst_dir="$2"

git clone https://github.com/SimonKagstrom/kcov.git "$src_dir"
cd "$src_dir" || exit
git checkout "$(git describe --tags --match=v\* "$(git rev-list --tags=v\* --max-count=1)")"
# https://gist.github.com/rponte/fdc0724dd984088606b0
apt-get --yes install binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev cmake
mkdir build
cd build || exit
cmake -DCMAKE_INSTALL_PREFIX="$dst_dir" ..
make install
