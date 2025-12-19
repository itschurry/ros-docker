FROM ros:jazzy-ros-base
LABEL authors="chlee-rdv"
LABEL maintainer="chlee-rdv"
ARG DEBIAN_FRONTEND=noninteractive 
ARG ROS_DISTRO="jazzy"
WORKDIR /root
# ----------------------------------------------------------------------------------------------
# [기본 유틸리티]
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo vim git wget curl tar unzip tree xz-utils udev xclip tmux \
    htop universal-ctags ripgrep \
    lsb-release gnupg2 software-properties-common \
    python3-tk apt-utils expect \
    gettext
# ----------------------------------------------------------------------------------------------
# [개발 도구]
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake g++ clang clangd clang-format pkg-config \
    net-tools gdb iproute2 usbutils can-utils \
    autoconf libtool libxext-dev libx11-dev libglvnd-dev \
    automake doxygen guvcview v4l-utils kmod libelf-dev \
    libpopt-dev libmuparser-dev
# ----------------------------------------------------------------------------------------------
# [X11/GUI 관련]
RUN apt-get update && apt-get install -y --no-install-recommends \
    mesa-utils x11-apps libspdlog-dev
# ----------------------------------------------------------------------------------------------
# [Python/ROS 빌드 관련]
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-colcon-common-extensions python3-pip python3-venv python3-rosdep python3-watchdog \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# ----------------------------------------------------------------------------------------------
# Upgrade pip and install Python dependencies
RUN python3 -m pip install \
    cantools \
    bitstring \
    numpy \
    pillow \
    python-can \
    websocket-client \
    --break-system-packages
# ultralytics \
# ----------------------------------------------------------------------------------------------
# [ROS 2 패키지 및 센서/디바이스 관련]
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
    ros-${ROS_DISTRO}-robot-localization \
    ros-${ROS_DISTRO}-image-geometry \
    ros-${ROS_DISTRO}-pointcloud-to-laserscan

# ----------------------------------------------------------------------------------------------
# [추가 ROS 2 도구]
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-foxglove-bridge ros-${ROS_DISTRO}-rosbridge-server
# ----------------------------------------------------------------------------------------------
# Final cleanup
RUN apt-get purge -y python3-click && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
