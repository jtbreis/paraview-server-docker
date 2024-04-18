FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu22.04

ARG NUMBER_PROCESSORS=4

#install dependencies
RUN apt-get update && apt-get install -y wget libgomp1 libegl1 libopengl-dev libgl1 mpich

RUN mkdir paraview
WORKDIR paraview

RUN wget "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.12&type=binary&os=Linux&downloadFile=ParaView-5.12.0-egl-MPI-Linux-Python3.10-x86_64.tar.gz" \ 
    && tar -xf download.php\?submit\=Download\&version\=v5.12\&type\=binary\&os\=Linux\&downloadFile\=ParaView-5.12.0-egl-MPI-Linux-Python3.10-x86_64.tar.gz \
    && rm -r download.php\?submit\=Download\&version\=v5.12\&type\=binary\&os\=Linux\&downloadFile\=ParaView-5.12.0-egl-MPI-Linux-Python3.10-x86_64.tar.gz

RUN mkdir data
EXPOSE 11111

CMD ["mpirun", "-np", "${NUMBER_PROCESSORS}", "./ParaView-5.12.0-egl-MPI-Linux-Python3.10-x86_64/bin/pvserver"]