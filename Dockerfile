FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

USER root
ARG NUMBER_PROCESSORS=4
ARG PORT=11111

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

#install dependencies
RUN apt-get update && apt-get install -y wget libgl1-mesa-dev libegl1 libxt-dev libqt5x11extras5-dev libqt5help5 qttools5-dev qtxmlpatterns5-dev-tools libqt5svg5-dev python3-dev python3-numpy libopenmpi-dev libtbb-dev ninja-build qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools

RUN useradd -m -d /home/paraview-user -s /bin/bash paraview-user \
    && usermod -aG sudo paraview-user \
    && echo 'paraview-user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Headless GPU rendering: avoid vtkXOpenGLRenderWindow without DISPLAY (see ParaView 6 --opengl-window-backend).
ENV NVIDIA_DRIVER_CAPABILITIES=graphics,utility,compute
ENV VTK_DEFAULT_OPENGL_WINDOW=vtkEGLRenderWindow

USER paraview-user

WORKDIR /home/paraview-user/pvserver

RUN wget -O paraview.tar.gz 'https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v6.0&type=binary&os=Linux&downloadFile=ParaView-6.0.1-MPI-Linux-Python3.12-x86_64.tar.gz' \
    && tar -xf paraview.tar.gz \
    && rm paraview.tar.gz

WORKDIR /home/paraview-user/data
EXPOSE ${PORT}

ENTRYPOINT ["/home/paraview-user/pvserver/ParaView-6.0.1-MPI-Linux-Python3.12-x86_64/bin/pvserver", "--opengl-window-backend=EGL"]
