#!/bin/bash -eu

script_dir=$(dirname "${BASH_SOURCE[0]}")
libgc_dockerfile="${script_dir}/../Dockerfile.libgc"

libgc_dockerfile_url="https://raw.githubusercontent.com/crystal-lang/distribution-scripts/master/linux/Dockerfile"

wget -q "${libgc_dockerfile_url}" -O "${libgc_dockerfile}"
