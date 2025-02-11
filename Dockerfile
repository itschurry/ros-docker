FROM ros:humble-ros-core
LABEL authors="chlee-rdv"
LABEL maintainer="chlee-rdv"
ARG DEBIAN_FRONTEND=noninteractive ENV TZ=Asia/Seoul
WORKDIR /root
# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# ----------------------------------------------------------------------------------------------
# Install common dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo vim git wget curl tar unzip tree xz-utils udev xclip tmux \
    build-essential cmake g++ net-tools gdb iproute2 usbutils can-utils \
    mesa-utils autoconf libtool pkg-config libxext-dev libx11-dev libglvnd-dev \
    python3-colcon-common python3-pip python3-venv \
    htop universal-ctags x11-apps libspdlog-dev ripgrep \
    lsb-release gnupg2 software-properties-common \
    python3-tk apt-utils expect \
    gettext libtool libtool-bin automake doxygen \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# python3-catkin-tools
# ----------------------------------------------------------------------------------------------
# Upgrade pip and install Python dependencies
RUN python3 -m pip install --upgrade pip setuptools \
    && python3 -m pip install \
        cantools \
        bitstring \
        numpy \
        pillow \
        python-can
        # numpy==1.20.3 \
        # pillow==9.5.0 \
# ----------------------------------------------------------------------------------------------
# ARG ROS_DISTRO="noetic"
# RUN apt-get update && apt-get install -y \ ros-${ROS_DISTRO}-rviz ros-${ROS_DISTRO}-robot \
#     ros-${ROS_DISTRO}-pcl-conversions ros-${ROS_DISTRO}-pcl-ros \
#     ros-${ROS_DISTRO}-roslint \
#     ros-${ROS_DISTRO}-foxglove-bridge \
#     ros-${ROS_DISTRO}-ros-numpy ros-${ROS_DISTRO}-geometry2 \
#     ros-${ROS_DISTRO}-tf2-sensor-msgs ros-${ROS_DISTRO}-move-base \
#     ros-${ROS_DISTRO}-move-base-msgs ros-${ROS_DISTRO}-navigation \
#     ros-${ROS_DISTRO}-sound-play alsa-utils ros-${ROS_DISTRO}-audio-common \
#     ros-${ROS_DISTRO}-realtime-tools libpcap0.8-dev \
#     ros-${ROS_DISTRO}-serial ros-${ROS_DISTRO}-rosserial ros-${ROS_DISTRO}-rosserial-arduino ros-${ROS_DISTRO}-can* \
#     ros-${ROS_DISTRO}-control-toolbox ros-${ROS_DISTRO}-joy \
#     ros-${ROS_DISTRO}-teleop-twist-joy ros-${ROS_DISTRO}-teleop-twist-keyboard \
#     ros-${ROS_DISTRO}-usb-cam \
#     guvcview v4l-utils kmod can-utils iproute2 libelf-dev \
#     libpopt-dev libmuparser-dev python3-pcl
RUN apt-get update && apt-get install -y \
    ros-humble-rviz2 \
    ros-humble-navigation2 ros-humble-nav2-bringup \
    ros-humble-pcl-conversions ros-humble-pcl-ros \
    ros-humble-ament-lint-auto ros-humble-ament-lint-common \
    ros-humble-geometry2 \
    ros-humble-tf2-sensor-msgs \
    ros-humble-realtime-tools \
    ros-humble-joy \
    ros-humble-teleop-twist-joy ros-humble-teleop-twist-keyboard \
    ros-humble-usb-cam \
    guvcview v4l-utils kmod can-utils iproute2 libelf-dev \
    libpopt-dev libmuparser-dev python3-pcl
# ----------------------------------------------------------------------------------------------
# Install additional ROS 2 tools
RUN apt-get update && apt-get install -y \
    ros-humble-foxglove-bridge
# ----------------------------------------------------------------------------------------------
# Final cleanup
RUN apt-get purge -y python3-click && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
