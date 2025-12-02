FROM osrf/ros:jazzy-desktop-full
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

#RUN groupadd --gid $USER_GID $USERNAME \
#    && useradd -m -s /bin/bash --uid $USER_UID --gid $USER_GID $USERNAME

# install sudo
RUN apt-get update && apt-get install -y sudo

# give docker user passwordless sudo
#RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
#    && chmod 0440 /etc/sudoers.d/${USERNAME} \
#    && usermod -aG dialout,video $USERNAME \
#    && echo "ubuntu:ubuntu123" | chpasswd) || true
# (optional) give ubuntu sudo + password too, if it exists

RUN id ubuntu 2>/dev/null && \
    (echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
     chmod 0440 /etc/sudoers.d/ubuntu \
     && usermod -aG dialout,video ubuntu \
     echo "ubuntu:ubuntu123" | chpasswd) || true

ENV ROS_DISTRO=jazzy
#ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Install required packages for adding new repositories
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    gnupg2 \
    nano \
    pip \
    python3-venv \
    python3-transforms3d


# Set up work directory with appropriate permissions


# Switch to the desired user
USER $USERNAME

RUN sudo apt-get update && \
    sudo apt-get install -y python3-colcon-common-extensions python3-empy usbutils && \
    sudo rm -rf /var/lib/apt/lists/*

# Create and use a virtual environment
RUN sudo python3 -m venv /opt/venv
RUN sudo chmod -R 777 /opt/venv
# Install packages using the virtual environment's pip
RUN /opt/venv/bin/pip install ultralytics transforms3d empy catkin_pkg lark


#catkin_pkg empy==3.3.4 wheel lark setuptools==65.5.0

# Set PYTHONPATH appropriately
ENV PYTHONPATH="/opt/venv/lib/python3.10/site-packages"


# Use an absolute path for the working directory
WORKDIR /ros_ws

# Clean up to reduce image size
RUN rm -rf /var/lib/apt/lists/*
# Initialize rosdep
RUN sudo rosdep update

ENV DEBIAN_FRONTEND=noninteractive
RUN sudo apt-get update && sudo apt install -y python3-vcstool python3-rosdep

RUN sudo apt update -y && sudo apt upgrade -y


RUN sudo apt install -y ros-jazzy-ros2-control \
                        ros-jazzy-ros2-controllers \
                        ros-jazzy-ament-cmake \
                        ros-jazzy-ros-gz-bridge \
                        ros-jazzy-gz-ros2-control \
                        ros-jazzy-ros-gz-sim \
                        ros-jazzy-tf2 \
                        ros-jazzy-tf-transformations \
                        ros-jazzy-moveit-kinematics



RUN sudo apt install -y ros-jazzy-librealsense2* \
                        ros-jazzy-realsense2-*

RUN sudo apt install -y ros-jazzy-moveit \
                        ros-jazzy-moveit-kinematics \
                        ros-jazzy-moveit-planners \
                        ros-jazzy-pilz-industrial-motion-planner \
                        libompl-dev 


RUN sudo apt-get update && sudo apt-get install -y \
    x11-apps \
    libx11-dev \
    # Add any additional libraries your app needs
    && sudo rm -rf /var/lib/apt/lists/*
    
# Initialize rosdep
RUN sudo rosdep update
RUN sudo apt-get update

RUN sudo apt-get install -y curl gnupg2 lsb-release
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
RUN echo "deb http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2-latest.list


RUN sudo apt-get install -y ros-jazzy-joint-state-publisher ros-jazzy-joint-state-publisher-gui ros-jazzy-controller-manager

RUN sudo apt update
RUN sudo apt clean

RUN sudo apt-get update && sudo apt-get install -y \
    && sudo rm -rf /var/lib/apt/lists/*

RUN sudo mkdir src && cd src \
    && sudo git clone https://github.com/ycheng517/ar4_ros_driver.git \
    && sudo git clone https://github.com/ycheng517/ar4_hand_eye_calibration.git \
    && sudo git clone https://github.com/BrentAChristensen/hyperactive.git \
    && sudo vcs import . --input ar4_hand_eye_calibration/hand_eye_calibration.repos \
    && sudo git clone https://github.com/BrentAChristensen/Peacock_data.git 
   
RUN sudo git clone https://github.com/mgonzs13/yolo_ros.git

RUN /opt/venv/bin/pip install -r yolo_ros/requirements.txt

RUN sudo rm -rf /var/lib/apt/lists/*

RUN sudo apt-get update

#move the easy_handeye2 folder into the /home/.ros
WORKDIR ~/
RUN sudo mkdir ~/.ros2

RUN sudo mv /ros_ws/src/Peacock_data/easy_handeye2  ~/.ros2/easy_handeye2

WORKDIR /ros_ws


RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && colcon build"

# Source the ROS2 setup file
RUN /bin/bash -c "source install/setup.bash"
# update the .bashrc file with source
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash && source /ros_ws/install/setup.bash && source /opt/venv/bin/activate" >> ~/.bashrc

# Run a default command, e.g., starting a bash shell
CMD ["bash"]

#Add default configuration to arcu markers

