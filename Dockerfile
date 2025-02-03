# Base image
FROM ros:noetic-robot-focal

# Maintainer
LABEL maintainer="chlee-rdv"

# Set environment variables
ARG DEBIAN_FRONTEND=noninteractive ENV TZ=Asia/Seoul
WORKDIR /root

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install common dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo vim git wget curl tar unzip tree xz-utils udev xclip tmux \
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
        python-can

        # pyyaml \
        # open3d==0.16.0 \
# Set ROS distribution and install ROS packages
ARG ROS_DISTRO="noetic"
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-rviz ros-${ROS_DISTRO}-robot \
    ros-${ROS_DISTRO}-pcl-conversions ros-${ROS_DISTRO}-pcl-ros \
    ros-${ROS_DISTRO}-roslint \
    ros-${ROS_DISTRO}-foxglove-bridge \
    ros-${ROS_DISTRO}-ros-numpy ros-${ROS_DISTRO}-geometry2 \
    ros-${ROS_DISTRO}-tf2-sensor-msgs ros-${ROS_DISTRO}-move-base \
    ros-${ROS_DISTRO}-move-base-msgs ros-${ROS_DISTRO}-navigation \
    ros-${ROS_DISTRO}-sound-play alsa-utils ros-${ROS_DISTRO}-audio-common \
    ros-${ROS_DISTRO}-realtime-tools libpcap0.8-dev \
    ros-${ROS_DISTRO}-control-toolbox ros-${ROS_DISTRO}-rosserial-arduino \
    ros-${ROS_DISTRO}-rosserial ros-${ROS_DISTRO}-can* ros-${ROS_DISTRO}-joy \
    ros-${ROS_DISTRO}-teleop-twist-joy ros-${ROS_DISTRO}-teleop-twist-keyboard \
    xboxdrv ros-${ROS_DISTRO}-serial ros-${ROS_DISTRO}-usb-cam \
    guvcview v4l-utils kmod can-utils iproute2 libelf-dev \
    libpopt-dev libmuparser-dev python3-pcl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Final cleanup
RUN apt-get purge -y python3-click && apt-get autoremove -y && apt-get clean
# ----------------------------------------------------------------------------------------------
# 사용자 추가 및 권한 부여
RUN useradd -m rdv && \
    echo "rdv ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rdv && \
    usermod -aG sudo,plugdev rdv

RUN cp -r /etc/skel/. /home/rdv/

USER rdv
WORKDIR /home/rdv

# NVM 설치
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
RUN export NVM_DIR="/home/rdv/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvm install 22
# NVM 관련 설정을 .bashrc에 추가
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc

# Clone and build Neovim from source
RUN git clone --depth 1 --branch v0.10.3 https://github.com/neovim/neovim.git && \
    cd neovim && \
    make CMAKE_BUILD_TYPE=Release -j4 && \
    sudo make install && \
    cd .. && rm -rf neovim
RUN sudo ln -s /usr/local/bin/nvim /usr/bin/nvim

# Vim Plugin 설치
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# Neovim 설정 파일 복사
RUN git clone https://github.com/lee-cheolhee/my_nvim.git
RUN mkdir -p /home/rdv/.config/nvim && \
    cp /home/rdv/my_nvim/nvim/init.vim /home/rdv/.config/nvim/
RUN mkdir -p /home/rdv/.config/nvim/plugged
# alias 설정
RUN echo "alias vi='nvim'" >> /home/rdv/.bash_aliases && \
    echo "alias vidiff='nvim -d'" >> /home/rdv/.bash_aliases

RUN nvim --headless +PlugInstall +qall
# ----------------------------------------------------------------------------------------------
# Git Auto completion setting
RUN curl -o ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
RUN echo 'if [ -f ~/.git-completion.bash ]; then . ~/.git-completion.bash; fi' >> ~/.bashrc
RUN curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
RUN echo 'if [ -f ~/.git-prompt.sh ]; then . ~/.git-prompt.sh; fi' >> ~/.bashrc
RUN echo 'export GIT_PS1_SHOWDIRTYSTATE=1' >> ~/.bashrc
RUN echo 'export GIT_PS1_SHOWSTASHSTATE=1' >> ~/.bashrc
RUN echo 'export GIT_PS1_SHOWUNTRACKEDFILES=1' >> ~/.bashrc
RUN echo 'export GIT_PS1_SHOWUPSTREAM="auto"' >> ~/.bashrc
RUN echo 'PS1="\\[\\e]0;\\u@\\h: \\w\\a\\]${debian_chroot:+($debian_chroot)}\\u@\\h:\\w \\$(__git_ps1 \\"[%s]\\")\\$ "' >> ~/.bashrc
# ----------------------------------------------------------------------------------------------

# Set default entrypoint
CMD ["/bin/bash"]
