# nrjavaserial-builder

Builds the [nrjavaserial](https://github.com/NeuronRobotics/nrjavaserial/) library and its native dependencies using a Docker container.

1. Use `./build-artifacts.sh` to build the library. 
2. It will automatically run `./build-container.sh` to build the Docker container if it hasn't been build yet.
3. After that it will use the container to clone the Git repository, build the native libraries followed by building the Java library.
4. Finally the resulting build artifacts are copied to the `artifacts` subdirectory which is mounted as a volume.

The [Dockerfile](Dockerfile) uses some environment variables that can be overriden. 