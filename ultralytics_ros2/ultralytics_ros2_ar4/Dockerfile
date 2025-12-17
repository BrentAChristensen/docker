FROM osrf/ros:jazzy-desktop-full
#API Key= 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
ARG USERNAME=docker
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ARG ROS_DISTRO=$ROS_DISTRO
# Environment Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=$ROS_DISTRO
ENV PYTHONPATH="/opt/venv/lib/python3.10/site-packages"

# Install necessary packages and set up user in a single step
RUN apt-get update && \
    apt-get install -y sudo passwd && \
    groupadd --gid $USER_GID $USERNAME && \
    useradd -m -s /bin/bash -u $USER_UID -g $USER_GID -G dialout,video,sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    echo "$USERNAME:$USERNAME" | chpasswd && \
    rm -rf /var/lib/apt/lists/*


# Install necessary packages and set up the environment in one layer
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    gnupg2 \
    nano \
    python3-venv \
    python3-transforms3d \
    python3-colcon-common-extensions \
    python3-empy \
    usbutils \
    libompl-dev \
    x11-apps \
    libx11-dev \
    python3-vcstool \
    python3-rosdep \
    ros-$ROS_DISTRO-ros2-control \
    ros-$ROS_DISTRO-ros2-controllers \
    ros-$ROS_DISTRO-ament-cmake \
    ros-$ROS_DISTRO-ros-gz-bridge \
    ros-$ROS_DISTRO-gz-ros2-control \
    ros-$ROS_DISTRO-ros-gz-sim \
    ros-$ROS_DISTRO-tf2 \
    ros-$ROS_DISTRO-tf-transformations \
    ros-$ROS_DISTRO-moveit-kinematics \
    ros-$ROS_DISTRO-librealsense2* \
    ros-$ROS_DISTRO-realsense2-* \
    ros-$ROS_DISTRO-moveit \
    ros-$ROS_DISTRO-moveit-planners \
    ros-$ROS_DISTRO-pilz-industrial-motion-planner \
    ros-$ROS_DISTRO-joint-state-publisher \
    ros-$ROS_DISTRO-joint-state-publisher-gui \
    ros-$ROS_DISTRO-controller-manager && \
    rm -rf /var/lib/apt/lists/*

# Set up ROS sources
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
    echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list

# Update and upgrade packages
RUN apt-get update && apt-get upgrade -y && apt-get clean

# Create Python virtual environment
RUN python3 -m venv /opt/venv && chmod -R 777 /opt/venv && \
    /opt/venv/bin/pip install ultralytics transforms3d empy catkin_pkg lark

# Initializing ROS dependencies
RUN rosdep update

RUN mkdir /ros_ws
WORKDIR /ros_ws/src
RUN sudo chmod -R 777 /ros_ws

# Set working directory and clone repositories

RUN git clone https://github.com/ycheng517/ar4_ros_driver.git && \
    git clone https://github.com/ycheng517/ar4_hand_eye_calibration.git && \
    git clone https://github.com/BrentAChristensen/hyperactive.git && \
    vcs import . --input ar4_hand_eye_calibration/hand_eye_calibration.repos && \
    git clone https://github.com/BrentAChristensen/Peacock_data.git && \
    git clone https://github.com/mgonzs13/yolo_ros.git

# Install Python requirements for yolo_ros
RUN /opt/venv/bin/pip install -r yolo_ros/requirements.txt

# Move directories
RUN sudo mkdir ~/.ros2 
RUN sudo mv /ros_ws/src/Peacock_data/easy_handeye2 ~/.ros2/easy_handeye2



WORKDIR /ros_ws
RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && colcon build"

# Source configurations

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash && source /ros_ws/install/setup.bash && source /opt/venv/bin/activate" >> ~/.bashrc
# Build workspace
USER $USERNAME
# Default command
CMD ["bash"]
