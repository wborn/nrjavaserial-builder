FROM ubuntu:18.04

ENV GIT_REPO_DIR="/nrjavaserial" \
    GIT_REPO_URL="https://github.com/NeuronRobotics/nrjavaserial.git" \
    ARTIFACTS_DIR="/artifacts"

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    g++ \
    g++-5-multilib \
    g++-5-multilib-arm-linux-gnueabi \
    g++-5-multilib-arm-linux-gnueabihf \
    gcc \
    git \
    g++-mingw-w64 \
    lib32gcc-7-dev \
    lib32mpx2 \
    lib32stdc++-7-dev \
    libx32asan4 \
    libx32gcc-7-dev \
    libx32stdc++-7-dev \
    make \
    openjdk-8-jdk

VOLUME ${ARTIFACTS_DIR}
WORKDIR /
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
