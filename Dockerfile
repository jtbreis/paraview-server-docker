ARG UBUNTU_RELEASE=20.04
ARG CUDA_VERSION=11.2.2
FROM nvcr.io/nvidia/cudagl:${CUDA_VERSION}-runtime-ubuntu${UBUNTU_RELEASE}

USER root
ARG NUMBER_PROCESSORS=4
ARG PORT 11111

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

#install dependencies
RUN apt-get update && apt-get install -y wget libgl1-mesa-dev libxt-dev libqt5x11extras5-dev libqt5help5 qttools5-dev qtxmlpatterns5-dev-tools libqt5svg5-dev python3-dev python3-numpy libopenmpi-dev libtbb-dev ninja-build qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools

RUN useradd -m -d /home/paraview-user -s /bin/bash paraview-user \
    && usermod -aG sudo paraview-user \
    && echo 'paraview-user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER paraview-user

WORKDIR /home/paraview-user/pvserver

RUN wget 'https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.13&type=binary&os=Linux&downloadFile=ParaView-5.13.0-RC2-egl-MPI-Linux-Python3.10-x86_64.tar.gz' \
    && tar -xf 'download.php?submit=Download&version=v5.13&type=binary&os=Linux&downloadFile=ParaView-5.13.0-RC2-egl-MPI-Linux-Python3.10-x86_64.tar.gz' \
    && rm -r 'download.php?submit=Download&version=v5.13&type=binary&os=Linux&downloadFile=ParaView-5.13.0-RC2-egl-MPI-Linux-Python3.10-x86_64.tar.gz'

WORKDIR /home/paraview-user/data
EXPOSE ${PORT}


# CMD ["mpirun", "-n", "${NUMBER_PROCESSORS}", "./ParaView-5.13.0-RC2-egl-MPI-Linux-Python3.10-x86_64/bin/pvserver"]
ENTRYPOINT [ "./../pvserver/ParaView-5.13.0-RC2-egl-MPI-Linux-Python3.10-x86_64/bin/pvserver"]