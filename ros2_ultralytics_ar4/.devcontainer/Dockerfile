ARG ROS_DISTRO=humble
FROM hyperactive/ros2:ultralytics AS deps

RUN userdel -r ubuntu || true

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

# Create ar4_ws and copy files
WORKDIR /root/ar4_ws
SHELL ["/bin/bash", "-c"]
COPY . /root/ar4_ws/src


USER $USERNAME
# Install workspace source code
WORKDIR /ar4_ws
RUN mkdir -p src \
    && cd src \
    && git clone -b iron https://github.com/ycheng517/ar4_ros_driver.git \
    && git clone -b iron https://github.com/ycheng517/ar4_hand_eye_calibration.git \
    && vcs import . --input ar4_hand_eye_calibration/hand_eye_calibration.repos \
    && git clone https://github.com/mgonzs13/yolo_ros.git 

RUN sudo rosdep install --from-paths src --ignore-src -r -y
   

# Colcon the ws
FROM deps AS builder
ARG CMAKE_BUILD_TYPE=Release
RUN source /opt/ros/${ROS_DISTRO}/setup.bash && colcon build

# Source the ROS2 setup file
RUN echo "source ~ar4_ws/install/setup.bash" >> ~/.bashrc

# Run a default command, e.g., starting a bash shell
CMD ["bash"]

# docker run --name ar4-container   --env DISPLAY=unix:0   --mount type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix,consistency=cached   --privileged   --rm   -it hyperactive/ros2/ultralytics:ar4
# docker exec -it ar4-container /bin/bash