# Base Image
FROM osrf/ros:jazzy-desktop-full

# Environment Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=jazzy
ENV PYTHONPATH="/opt/venv/lib/python3.10/site-packages"

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
    python3-vcstool \
    python3-rosdep \
    ros-jazzy-ros2-control \
    ros-jazzy-ros2-controllers \
    ros-jazzy-ament-cmake \
    ros-jazzy-ros-gz-bridge \
    ros-jazzy-gz-ros2-control \
    ros-jazzy-ros-gz-sim \
    ros-jazzy-tf2 \
    ros-jazzy-tf-transformations \
    ros-jazzy-moveit-kinematics \
    ros-jazzy-librealsense2* \
    ros-jazzy-realsense2-* \
    ros-jazzy-moveit \
    ros-jazzy-moveit-planners \
    ros-jazzy-pilz-industrial-motion-planner \
    libompl-dev \
    x11-apps \
    libx11-dev \
    ros-jazzy-joint-state-publisher \
    ros-jazzy-joint-state-publisher-gui \
    ros-jazzy-controller-manager && \
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

# Set working directory and clone repositories
WORKDIR /ros_ws/src
RUN git clone https://github.com/ycheng517/ar4_ros_driver.git && \
    git clone https://github.com/ycheng517/ar4_hand_eye_calibration.git && \
    git clone https://github.com/BrentAChristensen/hyperactive.git && \
    vcs import . --input ar4_hand_eye_calibration/hand_eye_calibration.repos && \
    git clone https://github.com/BrentAChristensen/Peacock_data.git && \
    git clone https://github.com/mgonzs13/yolo_ros.git

# Install Python requirements for yolo_ros
RUN /opt/venv/bin/pip install -r yolo_ros/requirements.txt

# Move directories
RUN mkdir ~/.ros2 && mv /ros_ws/src/Peacock_data/easy_handeye2 ~/.ros2/easy_handeye2

# Build workspace
WORKDIR /ros_ws
RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && colcon build"

# Source configurations
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash && source /ros_ws/install/setup.bash && source /opt/venv/bin/activate" >> ~/.bashrc

# Default command
CMD ["bash"]
