## Paraview Server using a DockerContainer with GPU support
A very basic Docker Container that uses an Nvidia/OpenGL base image for GPU support in ParaView.

Inside the container, the latest version of ParaView (5.12.0) is downloaded and installed from the ParaView website.
https://www.paraview.org/download/

Please make sure that you have a NVIDIA GPU and your Docker is set up to use the GPU.
For details see here: 

https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

Inside the container is a folder called "data" which can be mounted to the working folder.
Upon running the container the ./pvserver starts with the number of processors configured in the Dockerfile (standard 4).

To build the container:

```
docker build -t paraview .
```

To run the container:

```
docker run -itd --gpus all -p 11111:11111 --name paraview --mount type=bind,src=/your/data/path,target=/data paraview
```

Substitute /your/data/path to your desired data path on your machine.


The container is now running in the background, and you can connect to the ParaView by running the ssh command in your Terminal and then connecting to the Server in Paraview Client.

```
ssh -L 11111:localhost:11111 your-server-name
```

For more details see: https://docs.paraview.org/en/latest/ReferenceManual/parallelDataVisualization.html

For some reason the container stopps when you close the ParaView client, so you have to start the Container again by running

```
docker start paraview
```
