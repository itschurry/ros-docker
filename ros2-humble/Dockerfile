FROM ros:humble-perception
LABEL authors="chlee-rdv"
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /root
# ----------------------------------------------------------------------------------------------
# 지역 설정
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# ----------------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo neovim git wget curl tar unzip tree xz-utils udev xclip tmux \
    build-essential cmake g++ net-tools gdb iproute2 usbutils can-utils \
    mesa-utils autoconf libtool pkg-config libxext-dev libx11-dev x11proto-gl-dev libglvnd-dev \
    python3-pip python3-venv \
    htop nvtop universal-ctags x11-apps libspdlog-dev ripgrep \
    lsb-release gnupg2 software-properties-common \
    npm
# ----------------------------------------------------------------------------------------------
