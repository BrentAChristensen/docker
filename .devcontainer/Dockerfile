# Stage 1: Base dependencies setup with ROS
ARG ROS_DISTRO=jazzy
FROM ros:${ROS_DISTRO} AS base

# Create ros2_ws and copy files
WORKDIR /ar4_ws
SHELL ["/bin/bash", "-c"]
COPY . /ar4_ws/src

RUN apt-get update && \
    echo "APT Update completed" && \
    apt-get -y --quiet --no-install-recommends install gcc git python3 python3-pip && \
    echo "Basic dependencies installed" && \
    opt/venv/bin/pip3 install -r src/requirements.txt && \
    echo "Python dependencies installed" && \
    rosdep init && \
    echo "rosdep init completed" && \
    rosdep update && \
    echo "rosdep update completed" && \
    rosdep install --from-paths src --ignore-src -r -y && \
    echo "ROS dependencies installed" && \
    rm -rf /var/lib/apt/lists/*

# Install additional Python dependencies
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install  sphinx==8.0.0 sphinx-rtd-theme==3.0.0 lap==0.4.0


# Stage 2: Build the ROS workspace
FROM base AS builder
ARG CMAKE_BUILD_TYPE=Release
RUN source /opt/ros/${ROS_DISTRO}/setup.bash && colcon build

# Stage 3: Set up runtime environment with CUDA and other dependencies
FROM ros:jazzy

# Remove 'ubuntu' user if it exists
RUN userdel -r ubuntu || true

ARG USERNAME=docker
ARG USER_UID=1000
ARG USER_GID=$USER_UID

USER root

# Create non-root user and install essential packages
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo python3-pip python3-venv wget gnupg2 ca-certificates curl nano \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && usermod -aG dialout,video $USERNAME \
    && rm -rf /var/lib/apt/lists/*

# Install CUDA toolkit
#RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb \
#    && dpkg -i cuda-keyring_1.1-1_all.deb \
#    && rm cuda-keyring_1.1-1_all.deb \
#    && apt-get update \
#    && apt-get install -y cuda-toolkit-12-6 \
#    && rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/local/cuda-12.6/bin:${PATH}"

# Add NVIDIA machine learning repo key
#RUN mkdir -p /usr/share/keyrings \
#    && wget -qO - http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/7fa2af80.pub \
#    | gpg --dearmor > /usr/share/keyrings/nvidia-ml.gpg

# Add NVIDIA ml repo
#RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/nvidia-ml.gpg] http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" \
#    > /etc/apt/sources.list.d/nvidia-ml.list

# Install TensorRT
#RUN apt-get update \
#    && apt-get install -y tensorrt \
#    && rm -rf /var/lib/apt/lists/*

USER $USERNAME
WORKDIR /ar4_ws/src

# Clone repositories
RUN  git clone https://github.com/ycheng517/ar4_ros_driver.git \
    && git clone https://github.com/ycheng517/ar4_hand_eye_calibration.git \
    && git clone https://github.com/BrentAChristensen/impact.git \
    && git clone https://github.com/BrentAChristensen/hyperactive.git \
    && git clone https://github.com/BrentAChristensen/yolo_inference.git

WORKDIR /ar4_ws
USER root
# Install ROS dependencies
RUN apt-get update \
    && rosdep update \
    && rosdep install --from-paths src --ignore-src -r -y \
    && rm -rf /var/lib/apt/lists/*

USER $USERNAME
RUN vcs import src < src/ar4_hand_eye_calibration/hand_eye_calibration.repos

USER root
# Install additional ROS packages
RUN apt-get update \
    && apt-get install -y \
       ros-${ROS_DISTRO}-gz-ros2-control \
       ros-${ROS_DISTRO}-librealsense2* \
       ros-${ROS_DISTRO}-realsense2-* \
       ros-${ROS_DISTRO}-tf-transformations \
       ros-${ROS_DISTRO}-rqt \
       ros-${ROS_DISTRO}-rqt-joint-trajectory-controller \
       ros-${ROS_DISTRO}-moveit-configs-utils \
    && rm -rf /var/lib/apt/lists/*

# Setup Python environment and install additional tools
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu \
    && /opt/venv/bin/pip install ultralytics catkin_pkg empy==3.3.4 lark-parser

USER $USERNAME
WORKDIR /ar4_ws

# Setup the environment
RUN echo 'source /opt/ros/jazzy/setup.bash' >> ~/.bashrc \
    && echo 'source /workspaces/ar4_ws/install/setup.bash' >> ~/.bashrc \
    && echo 'export PYTHONPATH="/opt/venv/lib/python3.12/site-packages:$PYTHONPATH"' >> ~/.bashrc

# Optionally rebuild ROS workspace
#RUN source /opt/ros/${ROS_DISTRO}/setup.bash && colcon build

RUN echo 'source /opt/venv/bin/activate' >> ~/.bashrc
ENV PATH="/opt/venv/bin:${PATH}"

CMD ["bash"]
