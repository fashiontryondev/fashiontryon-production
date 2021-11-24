ARG IMAGE_NAME
ARG TARGETARCH
FROM ${IMAGE_NAME}:9.0-cudnn7-devel-ubuntu16.04 as base

FROM base as base-amd64

ENV NV_CUDNN_VERSION 7.1.4.18

ENV NV_CUDNN_PACKAGE "libcudnn7=$NV_CUDNN_VERSION-1+cuda9.0"
ENV NV_CUDNN_PACKAGE_NAME "libcudnn7"

FROM base-${TARGETARCH}



LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"
LABEL com.nvidia.cudnn.version="${NV_CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends --allow-downgrades --allow-change-held-packages \
    ${NV_CUDNN_PACKAGE} \
    && apt-mark hold ${NV_CUDNN_PACKAGE_NAME} && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository ppa:deadsnakes/ppa && apt-get update && apt-get install -y python3.7 python3.7-dev python3-pip
RUN pip3 install --upgrade Cython

RUN ln -sfn /usr/bin/python3.7 /usr/bin/python3 && ln -sfn /usr/bin/python3 /usr/bin/python && ln -sfn /usr/bin/pip3 /usr/bin/pip

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 test
RUN echo 'test:Fashiontryondev123!' | chpasswd

RUN apt-get install openssh-server -y && service ssh start
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]

EXPOSE 9623-9625

RUN pip3 install --upgrade pip setuptools
RUN apt-get install gfortran gcc musl-dev -y
RUN pip3 install Cython
RUN pip3 install torch==1.1.0 torchvision==0.3.0 -f https://download.pytorch.org/whl/cu90/torch_stable.html
RUN pip3 install cupy==6.0.0

RUN apt-get install sudo -y
RUN sudo ln /usr/local/cuda /usr/local/cuda-9.0

RUN sudo apt-get install curl git -y
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
RUN sudo apt-get install git-lfs
