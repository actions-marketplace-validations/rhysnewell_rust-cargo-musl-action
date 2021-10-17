#!/bin/bash

set -e

# version=3.21
# build=2
# wget https://cmake.org/files/v$version/cmake-$version.$build.tar.gz
# tar -xzvf cmake-$version.$build.tar.gz
# cd cmake-$version.$build/
# ./bootstrap
# make -j$(nproc)
# make install
# cmake --version
# cd ../


if [ "$1" == "build" ]; then
  args="--target x86_64-unknown-linux-musl --release $2"
else
  args=$2
fi
# split flags string into args
read -r -a args_array <<< "$args"
cargo "$1" "${args_array[@]}"

if [ "$1" == "build" ]; then
  release_dir="target/x86_64-unknown-linux-musl/release/"
  pushd $release_dir || { echo "Could not find directory: $release_dir"; exit 1; }
  for i in *
  do
    if file "$i" | grep "ELF 64-bit LSB executable" > /dev/null; then
      strip "$i"
      echo "Stripping $i"
    fi
  done
  popd || exit
  echo "::set-output name=release-dir::$release_dir"
fi
