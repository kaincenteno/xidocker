FROM ubuntu:22.04 AS xigame

RUN apt-get update && apt-get install -y \
    net-tools \
    nano \
    git \
    clang-11 \
    software-properties-common  \
    cmake \
    make \
    libluajit-5.1-dev \
    libzmq3-dev \
    libssl-dev \
    zlib1g-dev \
    mariadb-server \
    libmariadb-dev \
    luarocks \
    pip

ENV CC=/usr/bin/clang-11
ENV CXX=/usr/bin/clang++-11

ADD server server

RUN cd server && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j $(nproc)

WORKDIR /server

RUN chmod +x ./tools/wait_for_db_then_launch.sh

ENTRYPOINT ./tools/wait_for_db_then_launch.sh
