ARG ROS_DISTRO=humble
FROM ros:${ROS_DISTRO} AS deps

# Create ros2_ws and copy files
WORKDIR /root/ar4_ws
SHELL ["/bin/bash", "-c"]
COPY . /root/ar4_ws/src


#Add moveit and additional debugging tools
RUN apt-get update && apt-get install -y \   
    ros-${ROS_DISTRO}-tf-transformations \
    ros-${ROS_DISTRO}-ros2-controllers \
    ros-${ROS_DISTRO}-ros2-control \
    ros-${ROS_DISTRO}-joint-trajectory-controller \
    ros-${ROS_DISTRO}-gazebo-ros2-control \
    ros-${ROS_DISTRO}-ros-gz-bridge \
    ros-${ROS_DISTRO}-moveit* \
    ros-${ROS_DISTRO}-rqt* 

RUN rosdep update \
 && rosdep install --from-paths src --ignore-src -r -y
   

# Install ROS camera and visision packages
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-cv-bridge \
    ros-${ROS_DISTRO}-vision-msgs \
    ros-${ROS_DISTRO}-image-view \
    ros-${ROS_DISTRO}-librealsense2* \
    ros-${ROS_DISTRO}-realsense2-* \
    ros-${ROS_DISTRO}-pcl-* 

RUN rosdep update \
 && rosdep install --from-paths src --ignore-src -r -y
   

# Install dependencies
RUN apt-get update \
    && apt-get -y --quiet --no-install-recommends install \
    gcc \
    git \
    python3 \
    python3-pip
RUN pip3 install -r src/requirements.txt
RUN rosdep install --from-paths src --ignore-src -r -y
RUN pip3 install sphinx==8.0.0 sphinx-rtd-theme==3.0.0

# Colcon the ws
FROM deps AS builder
ARG CMAKE_BUILD_TYPE=Release
RUN source /opt/ros/${ROS_DISTRO}/setup.bash && colcon build

# Source the ROS2 setup file
RUN echo "source /root/ar4_ws/install/setup.bash" >> ~/.bashrc

# Run a default command, e.g., starting a bash shell
CMD ["bash"]
