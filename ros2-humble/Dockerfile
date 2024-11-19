FROM osrf/ros:humble-desktop
LABEL authors="chlee-rdv"
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /root
# ----------------------------------------------------------------------------------------------
# 지역 설정
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# ----------------------------------------------------------------------------------------------
RUN apt-get update
RUN apt-get install -y mesa-utils git autoconf libtool pkg-config libxext-dev libx11-dev x11proto-gl-dev

RUN apt-get update && apt-get install -y --no-install-recommends \
    vim git wget tar xz-utils udev \
    build-essential cmake g++ net-tools \
    python3-pip
    
RUN service udev restart

RUN python3 -m pip install --upgrade pip
# ----------------------------------------------------------------------------------------------
#RUN /bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash"
#ENV CMAKE_PREFIX_PATH=/opt/ros/noetic:/usr/local:/usr
#ENV PYTHONPATH=/usr/lib/python3/dist-packages:/opt/ros/noetic/lib/python3/dist-packages
#
#RUN apt-get install -y \
#    python3-rosdep python3-rosinstall python3-rosinstall-generator \
#    python3-wstool build-essential python3-catkin-tools python3-osrf-pycommon
#
#RUN rosdep init && rosdep update
# ----------------------------------------------------------------------------------------------
RUN git clone https://github.com/NVIDIA/libglvnd /root/libglvnd
WORKDIR /root/libglvnd
RUN /root/libglvnd/autogen.sh && /root/libglvnd/configure && make -j && make install
