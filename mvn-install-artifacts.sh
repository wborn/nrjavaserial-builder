#!/bin/bash
set -euo pipefail

pom_file=$(ls artifacts/*.pom | sort --version-sort | tail -n 1)

GROUP_ID="$(cat "$pom_file" | grep '^  <groupId>' | sed -E 's#\s+<groupId>(.+)</groupId>#\1#')"
ARTIFACT_ID="$(cat "$pom_file" | grep '^  <artifactId>' | sed -E 's#\s+<artifactId>(.+)</artifactId>#\1#')"
VERSION="$(cat "$pom_file" | grep '^  <version>' | sed -E 's#\s+<version>(.+)</version>#\1#')"

mvn install:install-file -Dfile=artifacts/nrjavaserial-$VERSION.pom         -DgroupId=$GROUP_ID -DartifactId=$ARTIFACT_ID -Dversion=$VERSION -Dpackaging=pom -DgeneratePom=false
mvn install:install-file -Dfile=artifacts/nrjavaserial-$VERSION.jar         -DgroupId=$GROUP_ID -DartifactId=$ARTIFACT_ID -Dversion=$VERSION -Dpackaging=jar -DgeneratePom=false
mvn install:install-file -Dfile=artifacts/nrjavaserial-$VERSION-javadoc.jar -DgroupId=$GROUP_ID -DartifactId=$ARTIFACT_ID -Dversion=$VERSION -Dpackaging=jar -DgeneratePom=false -Dclassifier=javadoc
mvn install:install-file -Dfile=artifacts/nrjavaserial-$VERSION-sources.jar -DgroupId=$GROUP_ID -DartifactId=$ARTIFACT_ID -Dversion=$VERSION -Dpackaging=jar -DgeneratePom=false -Dclassifier=sources
