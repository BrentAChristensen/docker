                                                                                  
ARG ROS_DISTRO=humble
FROM ultralytics/ros2:humble
ARG USERNAME=docker

# Set up work directory with appropriate permissions


# Switch to the desired user
USER $USERNAME

RUN sudo apt-get update && \
    sudo apt-get install -y python3-colcon-common-extensions python3-empy && \
    sudo rm -rf /var/lib/apt/lists/*

# Create and use a virtual environment
RUN sudo python3 -m venv /opt/venv
RUN sudo chmod -R 777 /opt/venv
# Install packages using the virtual environment's pip
RUN /opt/venv/bin/pip install catkin_pkg empy==3.3.4 wheel lark setuptools==65.5.0

# Set PYTHONPATH appropriately
ENV PYTHONPATH="/opt/venv/lib/python3.10/site-packages:${PYTHONPATH:-}"

# Use an absolute path for the working directory
WORKDIR /ros_ws

# Clean up to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# Initialize rosdep
#RUN sudo rosdep init && sudo rosdep update

# Clean up to reduce image size
RUN rm -rf /var/lib/apt/lists/*
# Initialize rosdep
RUN sudo rosdep init && \
    sudo rosdep update

RUN sudo mkdir src && cd src \
    && sudo git clone https://github.com/ycheng517/ar4_ros_driver.git \  
    && sudo git clone https://github.com/ycheng517/ar4_hand_eye_calibration.git  \
    && sudo git clone https://github.com/BrentAChristensen/hyperactive.git \
    && sudo vcs import . --input ar4_hand_eye_calibration/hand_eye_calibration.repos


# Initialize rosdep
RUN sudo rosdep update

RUN sudo rosdep install --from-paths src --ignore-src -r -y

RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"

# Source the ROS2 setup file
RUN /bin/bash -c "source install/setup.bash"
# update the .bashrc file with source
RUN echo "source opt/ros/humble/setup.bash && source /ros_ws/install/setup.bash && source /opt/venv/bin/activate" >> ~/.bashrc

# Run a default command, e.g., starting a bash shell
CMD ["bash"]
