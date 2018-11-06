#!/bin/bash -x
set -euo pipefail

# Create new clone of Git repository
rm -rf "$GIT_REPO_DIR"
git clone $GIT_REPO_URL "$GIT_REPO_DIR"

cd "$GIT_REPO_DIR/src/main/c/"

# Add missing OpenJDK 8 includes to Makefile.ubuntu64
sed -i 's#JDKINCLUDE=-I/usr/lib/jvm/java-7-openjdk-amd64/include/#JDKINCLUDE=-I/usr/lib/jvm/java-8-openjdk-amd64/include/ -I/usr/lib/jvm/java-8-openjdk-amd64/include/linux#g' Makefile.ubuntu64

# Disable using lock files in Makefile.ubuntu64
sed -i 's#-DLIBLOCKDEV#-DDISABLE_LOCKFILES#g' Makefile.ubuntu64
sed -i 's# -llockdev##g' Makefile.ubuntu64

# Recompile native Linux and Windows libraries
make -f Makefile.ubuntu64 linux
make -f Makefile.ubuntu64 windows

cd "$GIT_REPO_DIR"

# Fix missing Gradle properties
rm -f gradle.properties
cat > gradle.properties <<-EOI
ossrhUsername=SONATYPEJIRAUSERNAME
ossrhPassword=SONATYPEJIRAPASSWORD
EOI

# Build Java library with recompiled native libraries
./gradlew build

# Copy final build artifacts to volume
cp "$GIT_REPO_DIR/build/libs/"* "$ARTIFACTS_DIR"
