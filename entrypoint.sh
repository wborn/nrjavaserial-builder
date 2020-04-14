#!/bin/bash -x
set -euo pipefail

# Create new clone of Git repository
rm -rf "$GIT_REPO_DIR"
git clone $GIT_REPO_URL "$GIT_REPO_DIR"

# Disable using lock files
sed -i 's#-DLIBLOCKDEV#-DDISABLE_LOCKFILES#g' "$GIT_REPO_DIR/src/main/c/Makefile.ubuntu64"
sed -i 's# -llockdev##g' "$GIT_REPO_DIR/src/main/c/Makefile.ubuntu64"

# Recompile native Linux and Windows libraries
cd "$GIT_REPO_DIR/src/main/c"
make -f Makefile.ubuntu64 linux
make -f Makefile.ubuntu64 windows

cd "$GIT_REPO_DIR"

# Update library version
sed -Ei "s#app.version = .+#app.version = ${VERSION}#g" "$GIT_REPO_DIR/src/main/resources/com/neuronrobotics/nrjavaserial/build.properties"

# Build Java library with recompiled native libraries
./gradlew jar javadocJar sourcesJar

# Copy final build artifacts to volume
cp "$GIT_REPO_DIR/build/libs/"* "$ARTIFACTS_DIR"

# Generate POM file
pom_file="$ARTIFACTS_DIR/nrjavaserial-${VERSION}.pom"
cp "/nrjavaserial.pom" "$pom_file"

sed -i "s#<groupId></groupId>#<groupId>$POM_GROUP_ID</groupId>#g" "$pom_file"
sed -i "s#<artifactId></artifactId>#<artifactId>$POM_ARTIFACT_ID</artifactId>#g" "$pom_file"
sed -i "s#<version></version>#<version>$VERSION</version>#g" "$pom_file"
sed -i "s#<name></name>#<name>$POM_NAME</name>#g" "$pom_file"
sed -i "s#<description></description>#<description>$POM_DESCRIPTION</description>#g" "$pom_file"
sed -i "s#<url></url>#<url>$POM_URL</url>#g" "$pom_file"

# Inherit file ownership
chown -R "$(stat -c%u:%g "$ARTIFACTS_DIR")" "$ARTIFACTS_DIR"
