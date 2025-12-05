#!/bin/bash
xhost +local:
docker run --name ultralytics --env DISPLAY=unix$DISPLAY --device=/dev/video0 --mount type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix -it --privileged ultralytics_jazzy:ar4
xhost -local:
