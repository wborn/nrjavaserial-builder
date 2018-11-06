#!/bin/bash -x
set -euo pipefail

if [[ "$(docker images -q nrjavaserial-builder 2> /dev/null)" == "" ]]; then
	./build-container.sh
fi

mkdir -p artifacts
docker run --rm -v $PWD/artifacts:/artifacts nrjavaserial-builder
