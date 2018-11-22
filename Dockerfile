FROM ubuntu:18.04

ENV GIT_REPO_DIR="/nrjavaserial" \
    GIT_REPO_URL="https://github.com/NeuronRobotics/nrjavaserial.git" \
    ARTIFACTS_DIR="/artifacts" \
    VERSION="3.15.0.OH"

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
        g++ \
        g++-5-aarch64-linux-gnu \
        g++-5-multilib \
        g++-5-multilib-arm-linux-gnueabi \
        g++-5-multilib-arm-linux-gnueabihf \
        g++-5-powerpc-linux-gnu \
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
        openjdk-8-jdk \
        wget && \
    ln -s /usr/include/asm-generic /usr/include/asm && \
    ln -s /usr/bin/aarch64-linux-gnu-gcc-5 /usr/bin/aarch64-linux-gnu-gcc && \
    ln -s /usr/bin/aarch64-linux-gnu-g++-5 /usr/bin/aarch64-linux-gnu-g++ && \
    ln -s /usr/bin/arm-linux-gnueabi-gcc-5 /usr/bin/arm-linux-gnueabi-gcc && \
    ln -s /usr/bin/arm-linux-gnueabi-g++-5 /usr/bin/arm-linux-gnueabi-g++ && \
    ln -s /usr/bin/arm-linux-gnueabihf-gcc-5 /usr/bin/arm-linux-gnueabihf-gcc && \
    ln -s /usr/bin/arm-linux-gnueabihf-g++-5 /usr/bin/arm-linux-gnueabihf-g++ && \
    ln -s /usr/bin/powerpc-linux-gnu-gcc-5 /usr/bin/powerpc-linux-gnu-gcc && \
    ln -s /usr/bin/powerpc-linux-gnu-g++-5 /usr/bin/powerpc-linux-gnu-g++ && \
    mkdir -p /usr/local/powerpc-none-linux-gnuspe/bin && \
    ln -s /usr/bin/powerpc-linux-gnu-gcc-5 /usr/local/powerpc-none-linux-gnuspe/bin/powerpc-none-linux-gnuspe-gcc && \
    ln -s /usr/bin/powerpc-linux-gnu-g++-5 /usr/local/powerpc-none-linux-gnuspe/bin/powerpc-none-linux-gnuspe-g++ && \
    wget http://mirrors.kernel.org/ubuntu/pool/universe/l/lockdev/liblockdev1_1.0.3-1.5build1_amd64.deb -O /tmp/liblockdev1_1.0.3-1.5build1_amd64.deb && \
    dpkg -i /tmp/liblockdev1_1.0.3-1.5build1_amd64.deb && \
    wget http://mirrors.kernel.org/ubuntu/pool/universe/l/lockdev/liblockdev1-dev_1.0.3-1.5build1_amd64.deb -O /tmp/liblockdev1-dev_1.0.3-1.5build1_amd64.deb && \
    dpkg -i /tmp/liblockdev1-dev_1.0.3-1.5build1_amd64.deb

VOLUME ${ARTIFACTS_DIR}
WORKDIR /
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
