FROM ubuntu:focal
#FROM osrf/ros:noetic-desktop
LABEL authors="chlee-rdv"
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /root
# ----------------------------------------------------------------------------------------------
# 지역 설정
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# ----------------------------------------------------------------------------------------------
RUN apt-get update
RUN apt-get install -y mesa-utils git autoconf libtool python pkg-config libxext-dev libx11-dev x11proto-gl-dev

RUN apt-get update && apt-get install -y --no-install-recommends \
    vim git wget tar xz-utils udev \
    build-essential cmake g++ net-tools \
    python3-pip htop x11-apps
#python3-pip python3-osrf-pycommon python3-catkin-tools
    
RUN service udev restart

RUN python3 -m pip install --upgrade pip
# ----------------------------------------------------------------------------------------------
ARG ROS_DISTRO="noetic"

RUN apt-get update && apt-get install -y \
    lsb-release gnupg2 && \
    sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get update && apt-get install -y ros-noetic-desktop

RUN /bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash"
ENV CMAKE_PREFIX_PATH=/opt/ros/noetic:/usr/local:/usr
ENV PYTHONPATH=/usr/lib/python3/dist-packages:/opt/ros/noetic/lib/python3/dist-packages

RUN apt-get install -y \
    python3-rosdep python3-rosinstall python3-rosinstall-generator \
    python3-wstool build-essential python3-catkin-tools python3-osrf-pycommon

RUN rosdep init && rosdep update
# ----------------------------------------------------------------------------------------------
RUN git clone https://github.com/NVIDIA/libglvnd /root/libglvnd
WORKDIR /root/libglvnd
RUN /root/libglvnd/autogen.sh && /root/libglvnd/configure && make -j && make install

# ----------------------------------------------------------------------------------------------
#RUN apt-get update
#RUN apt-get install -y mesa-utils git autoconf libtool python pkg-config libxext-dev libx11-dev x11proto-gl-dev
#
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim git wget tar xz-utils udev \
    build-essential cmake g++ net-tools gdb iproute2 usbutils can-utils \
    python3-pip

# RUN service udev restart
# ----------------------------------------------------------------------------------------------
ARG ROS_DISTRO="noetic"
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-pcl-conversions ros-${ROS_DISTRO}-pcl-ros \
    ros-${ROS_DISTRO}-ros-numpy \
    ros-${ROS_DISTRO}-geometry2 \
    ros-${ROS_DISTRO}-tf2-sensor-msgs \
    ros-${ROS_DISTRO}-move-base ros-${ROS_DISTRO}-move-base-msgs \
    ros-${ROS_DISTRO}-navigation \
    pcl-tools ros-${ROS_DISTRO}-map-server ros-${ROS_DISTRO}-octomap-mapping  ros-${ROS_DISTRO}-octomap-server \
    ros-${ROS_DISTRO}-sound-play alsa-utils ros-${ROS_DISTRO}-audio-common \
    ros-${ROS_DISTRO}-realtime-tools libpcap0.8-dev \
    ros-${ROS_DISTRO}-control-toolbox \
    ros-${ROS_DISTRO}-rosserial-arduino ros-${ROS_DISTRO}-rosserial \
    kmod can-utils iproute2 gcc-multilib libelf-dev libpopt-dev libmuparser-dev \
    ros-${ROS_DISTRO}-can* ros-${ROS_DISTRO}-joy \
    ros-${ROS_DISTRO}-teleop-twist-joy ros-${ROS_DISTRO}-teleop-twist-keyboard \
    xboxdrv ros-${ROS_DISTRO}-rosserial-arduino ros-${ROS_DISTRO}-serial \
    ros-${ROS_DISTRO}-usb-cam guvcview v4l-utils
# ----------------------------------------------------------------------------------------------
WORKDIR /root
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:borglab/gtsam-release-4.0
RUN apt-get install -y libgtsam-dev libgtsam-unstable-dev
# ----------------------------------------------------------------------------------------------
# CAN dependency
RUN python3 -m pip install cantools pyyaml bitstring numpy
# ----------------------------------------------------------------------------------------------
RUN apt-get purge -y python3-click
RUN apt-get install -y python3-cffi
# ----------------------------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-tk python3-catkin-tools \
    apt-utils expect

RUN python3 -m pip install --upgrade pip

RUN python3 -m pip uninstall -y numpy
RUN python3 -m pip uninstall -y numpy==1.24.4
RUN python3 -m pip install --target=/usr/local/lib/python3.8/dist-packages numpy==1.20.3
RUN python3 -m pip install --target=/usr/local/lib/python3.8/dist-packages pillow==9.5.0

RUN python3 -m pip install --target=/usr/local/lib/python3.8/dist-packages open3d==0.13.0
RUN python3 -m pip install --target=/usr/local/lib/python3.8/dist-packages python-can
RUN python3 -m pip install --target=/usr/local/lib/python3.8/dist-packages cantools
RUN python3 -m pip install --target=/usr/local/lib/python3.8/dist-packages grpcio
RUN python3 -m pip install --target=/usr/local/lib/python3.8/dist-packages black

RUN python3 -m pip install --target=/usr/local/lib/python3.8/dist-packages flask pgm-reader
RUN python3 -m pip install --target=/usr/local/lib/python3.8/dist-packages pyyaml
RUN python3 -m pip install --target=/usr/local/lib/python3.8/dist-packages pyserial
# ----------------------------------------------------------------------------------------------
# spdlog 패키지 설치
RUN apt-get install -y --no-install-recommends libspdlog-dev
# ----------------------------------------------------------------------------------------------
# APT 패키지 리스트 삭제(이미지 크기를 줄이기 위함)
#RUN apt-get clean && sudo rm -rf /var/lib/apt/lists/*
