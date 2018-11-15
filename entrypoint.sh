#!/bin/bash -x
set -euo pipefail

# Create new clone of Git repository
rm -rf "$GIT_REPO_DIR"
git clone $GIT_REPO_URL "$GIT_REPO_DIR"

./patch-makefile.sh "$GIT_REPO_DIR/src/main/c/Makefile.ubuntu64"

# Recompile native Linux and Windows libraries
cd "$GIT_REPO_DIR/src/main/c"
make -f Makefile.ubuntu64 linux
make -f Makefile.ubuntu64 windows

cd "$GIT_REPO_DIR"

# Update library version
sed -i "s#3.15.0#${VERSION}#g" "$GIT_REPO_DIR/src/main/resources/com/neuronrobotics/nrjavaserial/build.properties"

# Build Java library with recompiled native libraries
./gradlew jar javadocJar sourcesJar

# Copy final build artifacts to volume
cp "$GIT_REPO_DIR/build/libs/"* "$ARTIFACTS_DIR"
