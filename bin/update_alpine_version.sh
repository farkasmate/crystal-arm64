#!/bin/bash -eu

script_dir=$(dirname "${BASH_SOURCE[0]}")
dotenv_file="${script_dir}/../.env"

source "${dotenv_file}"
wget -q "https://raw.githubusercontent.com/crystal-lang/crystal/${CRYSTAL_VERSION}/.circleci/config.yml" -O "/tmp/crystal_config.yaml"
distribution_scripts_version=$(yq -r ".parameters.distribution-scripts-version.default" < "/tmp/crystal_config.yaml")

crystal_alpine_dockerfile="https://raw.githubusercontent.com/crystal-lang/distribution-scripts/${distribution_scripts_version}/docker/alpine.Dockerfile"
crystal_makefile="https://raw.githubusercontent.com/crystal-lang/distribution-scripts/${distribution_scripts_version}/docker/Makefile"

wget -q "${crystal_alpine_dockerfile}" -O /tmp/crystal_alpine_dockerfile
wget -q "${crystal_makefile}" -O /tmp/crystal_makefile

base_docker_image=$(grep '^ARG base_docker_image=' /tmp/crystal_alpine_dockerfile | sed 's/^ARG base_docker_image=//')
base_docker_image_override=$(grep '^BUILD_ARGS_ALPINE :=.*base_docker_image=' /tmp/crystal_makefile | sed 's/^.*base_docker_image=\([^ ]*\)\ .*$/\1/')

if ! [[ "${base_docker_image}" =~ ^alpine:[[:alnum:]_.\-]*$ ]]
then
  echo "Failed to parse Alpine image: ${base_docker_image}"
  exit 1
fi

if [ -n "${base_docker_image_override}" ] && ! [[ "${base_docker_image_override}" =~ ^alpine:[[:alnum:]_.\-]*$ ]]
then
  echo "Failed to parse override Alpine image: ${base_docker_image_override}"
  exit 1
fi

if [ -n "${base_docker_image_override}" ]
then
  image="${base_docker_image_override}"
else
  image="${base_docker_image}"
fi

tag="${image//alpine:/}"

sed "s/^ALPINE_VERSION=.*$/ALPINE_VERSION=${tag}/" -i "${dotenv_file}"
