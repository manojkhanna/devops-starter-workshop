# Docker basics exercise

This section documents some basic docker commands

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

