#!/bin/bash -eu

script_dir=$(dirname "${BASH_SOURCE[0]}")
dotenv_file="${script_dir}/../.env"

deps_makefile="https://raw.githubusercontent.com/crystal-lang/distribution-scripts/master/linux/Makefile"

wget -q "${deps_makefile}" -O /tmp/deps_makefile

gc_version=$(grep '^GC_VERSION =' /tmp/deps_makefile | sed 's/^GC_VERSION =//' | tr -d '[:space:]')
shards_version=$(grep '^SHARDS_VERSION =' /tmp/deps_makefile | sed 's/^SHARDS_VERSION =//' | tr -d '[:space:]')

if [ -z "${gc_version}" ]
then
  echo "Failed to parse libgc version"
  exit 1
fi

if [ -z "${shards_version}" ]
then
  echo "Failed to parse shards version"
  exit 1
fi

sed "s/^GC_VERSION=.*$/GC_VERSION=${gc_version}/" -i "${dotenv_file}"
sed "s/^SHARDS_VERSION=.*$/SHARDS_VERSION=${shards_version}/" -i "${dotenv_file}"
