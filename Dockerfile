FROM nvidia/cuda:12.8.1-devel-ubuntu24.04

LABEL authors="itschurry"
LABEL maintainer="cheolhee75@icloud.com"
LABEL description="Base image with Ubuntu 24.04, CUDA 12.8, ROS Jazzy, ZED SDK 5.1"

# 환경 변수 설정 (대화형 설치 방지 및 로케일 설정)
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV ROS_DISTRO=jazzy
# ----------------------------------------------------------------------------------------------
# [기본 유틸리티]
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo vim git wget curl tar unzip tree xz-utils udev xclip locales \
    htop universal-ctags ripgrep \
    lsb-release gnupg2 software-properties-common \
    python3-tk apt-utils expect \
    gettext zstd
# ----------------------------------------------------------------------------------------------
# [개발 도구]
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 lsb-release build-essential cmake g++ clang clangd clang-format pkg-config \
    net-tools gdb iproute2 usbutils can-utils \
    autoconf libtool libxext-dev libx11-dev libglvnd-dev \
    automake doxygen guvcview v4l-utils kmod libelf-dev \
    libpopt-dev libmuparser-dev
# ----------------------------------------------------------------------------------------------
# [X11/GUI 관련]
RUN apt-get update && apt-get install -y --no-install-recommends \
    mesa-utils libgl1-mesa-dev libgomp1 x11-apps libspdlog-dev \
    && locale-gen en_US en_US.UTF-8 && apt-get clean && rm -rf /var/lib/apt/lists/*
# ----------------------------------------------------------------------------------------------
# 3. Install ROS 2 Jazzy Jalisco
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt-get update && apt-get install -y --no-install-recommends \
    ros-jazzy-desktop \
    python3-colcon-common-extensions \
    python3-rosdep \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init && rosdep update

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
    ros-${ROS_DISTRO}-pointcloud-to-laserscan

# ----------------------------------------------------------------------------------------------
# [추가 ROS 2 도구]
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-foxglove-bridge ros-${ROS_DISTRO}-rosbridge-server
# ---------------------------------------------------------
# 4. Install ZED SDK 5.1.0
# ---------------------------------------------------------
# ZED SDK 설치 시 필요한 의존성 미리 설치
RUN apt-get update && apt-get install -y --no-install-recommends \
    libusb-1.0-0-dev \
    libhidapi-libusb0 \
    libopenblas-dev \
    libpng-dev \
    libturbojpeg \
    zstd \
    lsb-release \
    libqt5opengl5 \
    libqt5xml5 \
    libarchive-dev \
    libqt5svg5 \
    && rm -rf /var/lib/apt/lists/*
 

# ZED SDK 다운로드 및 설치 (Silent Mode)
# 주의: ZED SDK 5.1.0의 정확한 링크는 Stereolabs 릴리즈 페이지에서 확인 필요. 
# 아래는 일반적인 네이밍 규칙을 따른 예시 링크입니다.
ARG ZED_SDK_URL="https://download.stereolabs.com/zedsdk/5.1.1/cu12/ubuntu24"

WORKDIR /tmp
RUN wget -q --no-check-certificate -O ZED_SDK_Linux.run ${ZED_SDK_URL} && \
    chmod +x ZED_SDK_Linux.run && \
    # Silent install 옵션: 드라이버 제외, 툴 포함, CUDA 체크 무시
    ./ZED_SDK_Linux.run -- silent && \
    rm ZED_SDK_Linux.run && \
    rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH=/usr/local/zed/lib:$LD_LIBRARY_PATH
RUN chmod -R 755 /usr/local/zed
# ----------------------------------------------------------------------------------------------
# Final cleanup
# RUN apt-get purge -y python3-click && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
