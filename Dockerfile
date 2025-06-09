# Base image
FROM ros:noetic-robot

LABEL authors="chlee-rdv"
LABEL maintainer="chlee-rdv"

# Set environment variables
ARG DEBIAN_FRONTEND=noninteractive ENV TZ=Asia/Seoul
WORKDIR /root

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ros keyring 수정
RUN rm -f /usr/share/keyrings/ros1-latest-archive-keyring.gpg /usr/share/keyrings/ros-archive-keyring.gpg /etc/apt/sources.list.d/ros1-latest.list
RUN apt-get update && apt-get install -y --no-install-recommends curl
RUN curl -sS https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros1-latest-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros1-latest-archive-keyring.gpg] http://packages.ros.org/ros/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" > /etc/apt/sources.list.d/ros1-latest.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo vim git wget tar unzip tree xz-utils udev xclip tmux \
    build-essential cmake g++ net-tools gdb iproute2 usbutils can-utils \
    mesa-utils autoconf libtool pkg-config libxext-dev libx11-dev libglvnd-dev \
    python3-pip python3-venv \
    htop universal-ctags x11-apps libspdlog-dev ripgrep \
    lsb-release gnupg2 software-properties-common \
    python3-tk python3-catkin-tools apt-utils expect \
    gettext libtool libtool-bin automake doxygen \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python dependencies
RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install \
    cantools \
    bitstring \
    numpy==1.20.3 \
    pillow==9.5.0 \
    python-can \
    websocket-client
# pyyaml \
# open3d==0.16.0 \

# Set ROS distribution and install ROS packages
ARG ROS_DISTRO="noetic"
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-rviz ros-${ROS_DISTRO}-robot \
    ros-${ROS_DISTRO}-pcl-conversions ros-${ROS_DISTRO}-pcl-ros \
    ros-${ROS_DISTRO}-roslint \
    ros-${ROS_DISTRO}-foxglove-bridge \
    ros-${ROS_DISTRO}-rosbridge-server \
    ros-${ROS_DISTRO}-ros-numpy ros-${ROS_DISTRO}-geometry2 \
    ros-${ROS_DISTRO}-tf2-sensor-msgs ros-${ROS_DISTRO}-move-base \
    ros-${ROS_DISTRO}-move-base-msgs ros-${ROS_DISTRO}-navigation \
    ros-${ROS_DISTRO}-sound-play alsa-utils ros-${ROS_DISTRO}-audio-common \
    ros-${ROS_DISTRO}-realtime-tools libpcap0.8-dev \
    ros-${ROS_DISTRO}-control-toolbox ros-${ROS_DISTRO}-rosserial-arduino \
    ros-${ROS_DISTRO}-rosserial ros-${ROS_DISTRO}-can* ros-${ROS_DISTRO}-joy \
    ros-${ROS_DISTRO}-teleop-twist-joy ros-${ROS_DISTRO}-teleop-twist-keyboard \
    xboxdrv ros-${ROS_DISTRO}-serial ros-${ROS_DISTRO}-usb-cam \
    ros-${ROS_DISTRO}-robot-localization \
    guvcview v4l-utils kmod can-utils iproute2 libelf-dev \
    libpopt-dev libmuparser-dev python3-pcl python3-watchdog clangd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN git clone -b 4.2.0 https://github.com/borglab/gtsam.git && \
    cd gtsam && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && cmake --build . -j6 && \
    sudo cmake --install .

# Final cleanup
RUN apt-get purge -y python3-click && apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache

CMD ["/bin/bash"]
