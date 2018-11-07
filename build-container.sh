#!/bin/bash -x
set -euo pipefail

docker build --no-cache --tag nrjavaserial-builder .
