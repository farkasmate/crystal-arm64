#!/bin/bash -eu

script_dir=$(dirname "${BASH_SOURCE[0]}")
dotenv_file="${script_dir}/../.env"

latest_tag=$(curl -s 'https://api.github.com/repos/crystal-lang/crystal/releases/latest' | jq -r '.tag_name')

sed "s/^CRYSTAL_VERSION=.*$/CRYSTAL_VERSION=${latest_tag}/" -i "${dotenv_file}"
