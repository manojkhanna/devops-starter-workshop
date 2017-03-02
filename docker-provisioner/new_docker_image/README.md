# Docker exercise

This section documents some basic docker commands

## Basics DIY

### Exercise 0
In your terminal, type:

```shell
docker run ubuntu /bin/echo “hello world”
```

What did we just do?

 * __docker run__: We told the “docker” program to execute the command “run”. 
 * __ubuntu__: This is the name of the image to create a container from.

What does Docker do when this command executes ?

* Checks whether Ubuntu image is locally available.
* Downloads the latest image from the “Docker Hub”.
* Download is made in multiple reusable “layers”.
* Layers are assembled and container is started.
* Inside the container the command “echo hello world” is run.
* After the command exits, the container exits.  

### Exercise 1

From your command prompt or docker terminal run

```shell
docker run -t -i ubuntu /bin/bash
```

This command 

* Starts Ubuntu container again. No re-download is needed since we already have the latest image.
* -t, -i: these flags tell Docker to allocate a TTY and start in interactive mode.

The container is started, but this time we have opened an interactive shell inside the container. Now, let us quickly run some commands in the shell. These will be run inside the container.

Try some of the common shell commands at the prompt

```shell
ls
hostname
ifconfig
vi
zip
```

Many of these commands would work in a full Ubuntu VM. But in the Ubuntu container they do not work as these commands are not packaged with the Ubuntu Docker image. Lightweight!

> The hostname command shows a random alphanumeric. This is the randomly-generated hostname of this Ubuntu container.

### Exercise 2 

Docker also proivdes a detached mode, where the container is started and keeps running in the background until killed

```shell
docker run -d ubuntu /bin/bash
```

* The -d flag tells docker to detach from this container.  
* The detached container is still executing the command but in background.
* The large alphanumeric string is the __container ID__ of this container. 
* This container is executing the /bin/bash command, but in background.

### Common Docker commands

```shell
docker # list all docker commands
docker [COMMAND] --help # help for a particular command
docker images # list all docker images
docker ps # list all running containers
docker ps -a # list all containers (running + stopped)
docker ps -a -q | xargs docker rm # DELETE all containers
docker stop [CONTAINER NAME] # stop docker container
docker run … --name some_name # set name of container to be created.
docker run -it … # run container and start a shell
```

## Creating a new docker image

From the root direcotry create a folder for adding our new image

```shell
mkdir -p docker-provisioner/new_docker_image
cd docker-provisioner/new_docker_image
```

Create an empty docker file

```shell
touch Dockerfile
```

Add syntax to create a new image in this file

```shell
# Using “ubuntu” as Base Image.
FROM ubuntu
RUN apt-get -y update && apt-get install -y fortunes 
CMD /usr/games/fortune -a
```

Build the image 

```shell
docker build -t docker-fortunes .
```

What did we just do?

#### FROM: 
* Told Docker to use “ubuntu” as base image.
* FROM should always be first instruction.

#### CMD
* Only one CMD line in a Dockerfile.
* When container is run, execute this command (print out a fortune). 
