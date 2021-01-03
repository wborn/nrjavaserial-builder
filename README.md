# nrjavaserial-builder

[![Build Status](https://github.com/wborn/nrjavaserial-builder/workflows/build%20artifacts/badge.svg?event=push)](https://github.com/wborn/nrjavaserial-builder/actions?query=workflow%3A%22build+artifacts%22+event%3Apush+branch%3Amaster)
[![EPL-2.0](https://img.shields.io/badge/license-EPL%202-green.svg)](https://opensource.org/licenses/EPL-2.0)

Builds the [nrjavaserial](https://github.com/NeuronRobotics/nrjavaserial/) library and its native dependencies using a Docker container.

1. Use `./build-artifacts.sh` to build the library. 
2. It will automatically run `./build-container.sh` to build the Docker container if it hasn't been build yet.
3. After that it will use the container to clone the Git repository, build the native libraries followed by building the Java library.
4. Finally the resulting build artifacts are copied to the `artifacts` subdirectory which is mounted as a volume.
5. To install the artifacts into the local Maven repository run the `./mvn-install-artifacts.sh` script.

The [Dockerfile](Dockerfile) uses some environment variables that can be overriden.
