FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    git \
    cmake \
    build-essential \
    qtbase5-dev \
    qttools5-dev \
    qttools5-dev-tools \
    libqt5opengl5-dev \
    libqt5svg5-dev \
    libqt5websockets5-dev \
    libeigen3-dev \
    libboost-all-dev \
    libflann-dev \
    libgdal-dev \
    gdal-bin \
    libproj-dev \
    libtiff-dev \
    libpng-dev \
    libjpeg-dev \
    zlib1g-dev \
    liblaszip-dev \
    libxerces-c-dev \
    libmuparser-dev \
    xvfb && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --recursive --branch v2.13.2 \
    https://github.com/CloudCompare/CloudCompare.git \
    /CloudCompare && \
    mkdir /CloudCompare/build && \
    cd /CloudCompare/build && \
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DPLUGIN_STANDARD_QCSF=ON \
        -DPLUGIN_IO_QLAS=ON \
        -DOPTION_USE_GDAL=ON \
        -DOPTION_BUILD_TESTS=OFF \
        -DOPTION_BUILD_CCVIEWER=OFF && \
    cmake --build . --parallel "$(nproc)" && \
    cmake --install .

RUN wget -qO /tmp/miniconda.sh \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

ENV PATH="/opt/conda/bin:$PATH"

RUN conda config --system --remove-key channels && \
    conda config --system --add channels conda-forge && \
    conda config --system --set channel_priority strict

RUN conda create -y -n lidar \
    python=3.10 \
    pdal \
    proj-data && \
    conda clean -afy

ENV PATH="/opt/conda/envs/lidar/bin:$PATH"

ENV QT_QPA_PLATFORM=offscreen
ENV XDG_RUNTIME_DIR=/tmp

WORKDIR /project


