#!/bin/bash -eu

script_dir=$(dirname "${BASH_SOURCE[0]}")
dotenv_file="${script_dir}/../.env"

source "${dotenv_file}"
wget -q "https://raw.githubusercontent.com/crystal-lang/crystal/${CRYSTAL_VERSION}/.circleci/config.yml" -O "/tmp/crystal_config.yaml"
distribution_scripts_version=$(yq -r ".parameters.distribution-scripts-version.default" < "/tmp/crystal_config.yaml")

deps_makefile="https://raw.githubusercontent.com/crystal-lang/distribution-scripts/${distribution_scripts_version}/linux/Makefile"

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
