A very basic Docker Container that uses an Nvidia/OpenGL base image for GPU support in ParaView.
Inside the container the latest version of ParaView (5.12.0) is downloaded and installed from the ParaView website.

Inside the container there is a folder called "data" which can be mounted to the working folder.
Upon Running the Container the ./pvserver is started with the number of processors configured in the Docker file (standard 4).

To build the container:

'docker build -t paraview .'

To run the container:

'docker run -itd --gpus all -p 11111:11111 --name paraview --mount type=bind,src=/your/data/path,target=/data paraview'

The container is now running in the background and you can connect to the ParaView by running the ssh command in your Terminal and then connect to the Server in Paraview.
'ssh -L 11111:localhost:11111 your-server-name'

For some reason the container stopps when you close the ParaView client, so you have to start the Container again by running

'docker start paraview'