#!/bin/bash -eu

script_dir=$(dirname "${BASH_SOURCE[0]}")
dotenv_file="${script_dir}/../.env"

source "${dotenv_file}"
wget -q "https://raw.githubusercontent.com/crystal-lang/crystal/${CRYSTAL_VERSION}/.circleci/config.yml" -O "/tmp/crystal_config.yaml"
distribution_scripts_version=$(yq -r ".parameters.distribution-scripts-version.default" < "/tmp/crystal_config.yaml")

libgc_dockerfile="${script_dir}/../Dockerfile.libgc"
libgc_dockerfile_url="https://raw.githubusercontent.com/crystal-lang/distribution-scripts/${distribution_scripts_version}/linux/Dockerfile"

wget -q "${libgc_dockerfile_url}" -O "${libgc_dockerfile}"
