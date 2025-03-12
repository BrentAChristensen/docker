FROM ultralytics/ultralytics

# Add vscode user
ARG USERNAME=docker
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && usermod -aG dialout,video $USERNAME



# Install required packages for adding new repositories
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    gnupg2 \
    nano \
    pip \
    python3-transforms3d

# Set up the keys and sources for ROS 2
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | apt-key add - && \
    echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list

RUN sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
RUN sudo sh -c 'echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
RUN sudo apt update

RUN sudo sh -c 'echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
RUN sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key adv

# Prevent prompts and install ROS Humble Desktop
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y ros-humble-desktop \
                                        python3-vcstool \
                                        python3-rosdep

RUN sudo apt install -y ros-humble-ros2-control \
                        ros-humble-ros2-controllers \
                        ros-humble-ament-cmake \
                        ros-humble-ros-gz-bridge \
                        ros-humble-ros-gz-sim

RUN sudo apt install -y ros-humble-librealsense2* \
                        ros-humble-realsense2-*

RUN sudo apt install -y nano ros-humble-moveit*
RUN sudo apt-get update && apt-get install -y \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN sudo apt-get update && apt-get install -y \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

USER $USERNAME
