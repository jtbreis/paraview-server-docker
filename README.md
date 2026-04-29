## Paraview Server using a DockerContainer with GPU support
A very basic Docker Container that uses an Nvidia/OpenGL base image for GPU support in ParaView.

Inside the container, ParaView 6.0.1 (MPI, Linux x86_64) is downloaded and installed from the ParaView website.
https://www.paraview.org/download/

Use ParaView 6.0.1 for the desktop client as well; mismatched client and server versions cause connection handshake failures.

Please make sure that you have a NVIDIA GPU and your Docker is set up to use the GPU.
For details see here: 

https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

The image sets EGL headless rendering (`--opengl-window-backend=EGL` and `NVIDIA_DRIVER_CAPABILITIES` including `graphics`) so `pvserver` does not need an X server. Without that, you may see `bad X server connection. DISPLAY=` even though the client connected. If you start `pvserver` by hand inside the container, use the same flag or rely on `VTK_DEFAULT_OPENGL_WINDOW=vtkEGLRenderWindow` from the image.

Inside the container is a folder called "data" which can be mounted to the working folder.
Upon running the container the ./pvserver starts with the number of processors configured in the Dockerfile (standard 4).

To build the container:

```
docker build -t paraview .
```

To run the container:

```
docker run -p 11111:11111 -itd --gpus all --name paraview -v $PWD:/home/paraview-user/data ghcr.io/jtbreis/pvserver
```
For local build:
```
docker run -p 11111:11111 -itd --gpus all --name paraview -v $PWD:/home/paraview-user/data paraview
```

The container is now running in the background, and you can connect to the ParaView by running the ssh command in your Terminal and then connecting to the Server in Paraview Client.

```
ssh -L 11111:localhost:11111 your-server-name
```

For more details see: https://docs.paraview.org/en/latest/ReferenceManual/parallelDataVisualization.html

For some reason the container stops when you close the ParaView client, so you have to start the Container again by running

```
docker start paraview
```
