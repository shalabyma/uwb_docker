NEXT STEPS 0) upate this liste based on my other handwritten list 1) git this, 2) uwb_ros2, 3) figure out how to run everything using one command 4) docker compose 5) rosbag
HOW DO I PUBLISH TOPICS BETWEEN CONTAINERS OR SOMETHING TO STORE ALL TOPICS TO A ROS BAG

FROM osrf/ros:melodic-desktop

SHELL ["bin/bash", "-c"]

# dependencies
RUN apt-get update --fix-missing && \
    apt-get install -y git \
                       nano \
                       python3-pip \
                       tmux \ 
                       usbutils

RUN pip3 install --upgrade pip
RUN pip3 install numpy \
                 scipy \
                 matplotlib \
                 msgpack \
                 serial \
                 rospkg \
                 empy \
                 genpy

RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

# RUN mkdir -p src/uwb_interface
COPY ./uwb_interface /src/uwb_interface
VOLUME ./uwb_interface /src/uwb_interface

RUN mkdir -p catkin_ws/src
COPY ./uwb_ros /catkin_ws/src/uwb_ros
RUN source /opt/ros/melodic/setup.bash \
    && cd catkin_ws \
    && catkin_make -DPYTHON_EXECUTABLE=/usr/bin/python3
RUN mkdir -p catkin_ws/src/uwb_ros
VOLUME ./uwb_ros /catkin_ws/src/uwb_ros

RUN echo "source ./catkin_ws/devel/setup.bash" >> ~/.bashrc

RUN cd /src/uwb_interface && pip3 install -e .

