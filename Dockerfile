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
    build-essential cmake g++ clangd net-tools gdb iproute2 usbutils can-utils \
    mesa-utils autoconf libtool pkg-config libxext-dev libx11-dev libglvnd-dev \
    htop universal-ctags x11-apps libspdlog-dev ripgrep \
    lsb-release gnupg2 software-properties-common \
    python3-tk apt-utils expect \
    gettext libtool libtool-bin automake doxygen

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-colcon-common-extensions python3-pip python3-venv python3-rosdep \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# python3-catkin-tools
# ----------------------------------------------------------------------------------------------
# Upgrade pip and install Python dependencies
RUN python3 -m pip install --upgrade pip setuptools \
    && python3 -m pip install \
        cantools \
        bitstring \
        numpy==1.23.5 \
        pillow \
        python-can \
        ultralytics
        # numpy==1.20.3 \
        # pillow==9.5.0 \
# ----------------------------------------------------------------------------------------------
ARG ROS_DISTRO="humble"
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-ament-cmake \
    ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
    ros-${ROS_DISTRO}-diagnostic-updater \
    ros-${ROS_DISTRO}-rviz2 \
    ros-${ROS_DISTRO}-navigation2 ros-${ROS_DISTRO}-nav2-bringup \
    ros-${ROS_DISTRO}-pcl-conversions ros-${ROS_DISTRO}-pcl-ros \
    ros-${ROS_DISTRO}-ament-lint-auto ros-${ROS_DISTRO}-ament-lint-common \
    ros-${ROS_DISTRO}-geometry2 \
    ros-${ROS_DISTRO}-tf2-sensor-msgs \
    ros-${ROS_DISTRO}-realtime-tools \
    ros-${ROS_DISTRO}-cv-bridge ros-${ROS_DISTRO}-image-transport ros-${ROS_DISTRO}-vision-msgs \
    ros-${ROS_DISTRO}-joy \
    ros-${ROS_DISTRO}-teleop-twist-joy ros-${ROS_DISTRO}-teleop-twist-keyboard \
    ros-${ROS_DISTRO}-usb-cam \
    ros-${ROS_DISTRO}-joint-state-publisher \
    ros-${ROS_DISTRO}-moveit \
    ros-${ROS_DISTRO}-pluginlib \
    ros-${ROS_DISTRO}-robot-state-publisher \
    ros-${ROS_DISTRO}-ros2-controllers \
    ros-${ROS_DISTRO}-ros2-control \
    ros-${ROS_DISTRO}-urdf-launch \
    ros-${ROS_DISTRO}-xacro \
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
