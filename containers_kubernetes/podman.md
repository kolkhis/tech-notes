# podman

Podman is a container engine for developing, managing, and running OCI Containers on a Linux System.
OCI (Open Container Initiative) Containers are a kind of package that encapsulate your application and all its dependencies.


## Table of Contents
* [Podman Cheatsheet](#podman-cheatsheet) 
* [Building a Container from a Dockerfile](#building-a-container-from-a-dockerfile) 
* [Running a Container with Podman (Apache HTTP Server)](#running-a-container-with-podman-apache-http-server) 
* [Stopping a Container](#stopping-a-container) 
* [Avoiding Port Conflicts](#avoiding-port-conflicts) 
* [Pods vs. Containers](#pods-vs-containers) 
    * [Containers](#containers) 
    * [Pods](#pods) 
* [List of Podman Commands](#list-of-podman-commands) 
* [Managing Image Storage with Podman](#managing-image-storage-with-podman) 
    * [Podman Storage Configuration File](#podman-storage-configuration-file) 
    * [Directory Structure in `/varlib/containers/storage`](#directory-structure-in-varlibcontainersstorage) 



## Podman Cheatsheet
```bash
cd /var/lib/containers/storage/      # Where container images are stored
vi /var/lib/containers/storage.conf  # Edit the storage configuration file.  

# Basic Container Commands
podman ps                       # Show running containers
podman ps -a                    # Show all containers (including stopped ones)
podman start 'container'        # Start a stopped container
podman stop 'container'         # Stop a running container
podman restart 'container'      # Restart a container
podman rm 'container'           # Remove a stopped container
podman rm -f 'container'        # Force remove a running container
podman logs 'container'         # Show logs for a container
podman build -t imageName .     # Build a container image from a Dockerfile (in the . directory)

# Running Containers
podman run 'image'              # Run a container from an image
podman run -d 'image'           # Run a container in detached mode
podman run -dt 'image'          # Run a container in detached mode and give it its own TTY
podman run --name 'name' *image* # Run container with a specific name
podman run -p 'host_port':*container_port* *image*  # Map ports between host and container
podman run -v 'host_path':*container_path* *image*  # Mount a host directory in the container

# Images Management
podman images                   # List all images
podman pull 'image'             # Pull an image from a registry
podman rmi 'image'              # Remove an image
podman inspect 'image'          # View detailed information about an image

# Inspecting Containers
podman inspect 'container'      # View detailed information about a container
podman top 'container'          # Display processes running inside a container
podman stats 'container'        # Show resource usage statistics for a container

# Networking
podman port 'container'         # List port mappings for a container
podman network ls               # List Podman networks
podman network create 'name'    # Create a custom network
podman network rm 'name'        # Remove a custom network

# Volumes
podman volume create 'volume'   # Create a new volume
podman volume ls                # List all volumes
podman volume rm 'volume'       # Remove a volume

# Pod Management
podman pod create 'name'        # Create a new pod
podman pod ls                   # List all pods
podman pod rm 'name'            # Remove a pod
podman pod ps                   # Show containers in pods

# System and Cleanup
podman system prune             # Remove all unused containers, images, and networks
podman system df                # Show disk usage information for Podman
podman version                  # Show Podman version
podman info                     # Display system-level information about Podman
```

## Building a Container from a Dockerfile
* [Source: Docker Documentation](https://docs.docker.com/build/concepts/dockerfile/#dockerfile-syntax)

Building a container image from a Dockerfile is done using `podman build`.  
1. Make a Dockerfile in a directory.  
   ```Dockerfile
   # syntax=docker/dockerfile:1
   # Get the base image
   FROM ubuntu:22.04
    
   # Install dependencies (environment setup)
   RUN apt-get update && apt-get install -y python3 python3-pip
   RUN pip install flask==3.0.*
   
   # Copy files from the local directory into the container
   COPY hello.py /
    
   # Set environment variables
   ENV FLASK_APP=hello
   # Expose port 8000 to the host machine
   EXPOSE 8000
   # Set the command to run when the container starts
   CMD ["flask", "run", "--host", "0.0.0.0", "--port", "8000"]
   ```

2. Build the container image from the Dockerfile.  
   ```bash
   podman build -t kol_hello .
   # or, to add a tag
   podman build -t kol_hello:latest .
   ```
    * `-t kol_hello`: Specify a name and tag for the image. The tag is optional.  
    * `.`: Specifies the path to the directory containing the Dockerfile.  


## Running a Container with Podman (Apache HTTP Server)
```bash
podman run -dt -p 8080:80/tcp docker.io/library/httpd 
```
This starts a container that runs an Apache HTTP server, on the host machine's port `8080`, and port `80` internal to the container
* `-d`: Run in detached mode. The container will run in the background without
  attaching to the terminal.  
* `-t`: Allocates a pseudo-TTY. This means that the container will have its
  own pseudo-terminal.  
* `-p 8080:80/tcp`: Maps ports between the host machine and the container.
    * The host machine's port `8080` will be mapped to the container's port `80` over TCP.  
    * You can access the HTTP server on the host using `localhost:8080`, and it will 
      forward to the container's default HTTP port (`80`), where the Apache server listens.  

You can then access the container by hitting `localhost:8080` with `curl`:
```bash
curl 127.0.0.1:8080
```
This can be useful for testing a container that's running a web server or API.  

---

## Stopping a Container
Stopping a container is done with `podman stop`
```bash
podman stop container_name
```
The `container_name` can either be the container's name, or the container's ID.  

Stopping a running container doesn't remove the image it was created from.  
Once the image is downloaded, you'll need to manually remove it.  




## Avoiding Port Conflicts

Each container should be assigned a different port on the host system.  
Services cannot share ports on a system. The first one to bind a port will win.    

Kubernetes automatically handles port conflicts by assigning a new port to each
container.  


## Pods vs. Containers

Containers and pods are two different concepts.  

Containers are individual instances of an application, focused on running a single
process or service.  

Pods are essentially a layer of abstraction on top of containers, used to group
containers that work together closely and share their network and storage.  


### Containers
Containers are single, isolated application instances.  

A container is an isolated instance of an application with its own filesystem, 
network stack, and process space.  
It runs a single process or service (though it can technically run multiple
processes).  

Containers package an application and its dependencies, making it portable and 
consistent across environemtns.  

Containers are the basic unit of deployment.
They're intended to run a single microservice or an application process.  

---


### Pods


A pod is collection of one or more containers that are tightly coupled and share the
same network and storage resources. 
Containers within a pod can communicate with each other via `localhost` and share volumes.  

All containers within a pod share the same contexts.
This means they share an IP address, network namespace, and storage volumes. 
This enables them to work closely together as parts of a single service.  

In Kubernetes, a pod is the smallest deployable unit. Not a container. 
Even if there is only one container, it will still be part of a pod.  
Pods enable better organization and scaling of applications by allowing multiple
containers to function as a single unit. 

---

## List of Podman Commands
`man://podman 330`

| Command | Description
|-|-|
| `podman attach`      |  Attach to a running container.
| `podman auto-update` |  Auto update containers according to their auto-update policy
| `podman build`       |  Build a container image using a Containerfile.
| `podman farm`        |  Farm out builds to machines running podman for different architectures
| `podman commit`      |  Create new image based on the changed container.
| `podman completion`  |  Generate shell completion scripts
| `podman compose`     |  Run Compose workloads via an external compose provider.
| `podman container`   |  Manage containers.
| `podman cp`          |  Copy files/folders between a container and the local filesystem.
| `podman create`      |  Create a new container.            
| `podman diff`        |  Inspect changes on a container or image's filesystem.
| `podman events`      |  Monitor Podman events
| `podman exec`        |  Execute a  command in a running container.
| `podman export`      |  Export a  container's filesystem contents as a tar archive.
| `podman generate`    |  Generate structured data based on containers, pods or volumes.
| `podman healthcheck` |  Manage healthchecks for containers
| `podman history`     |  Show the history of an image.
| `podman image`       |  Manage images.
| `podman images`      |  List images in local storage.
| `podman import`      |  Import a tarball and save it as a filesystem image.
| `podman info`        |  Display Podman related system information. 
| `podman init`        |  Initialize one or more containers
| `podman inspect`     |  Display a container,  image,  volume,  network, or pod's configuration.
| `podman kill`        |  Kill the main process in one or more containers.
| `podman load`        |  Load image(s)  from a tar archive into container storage.
| `podman login`       |  Log in to a container registry.
| `podman logout`      |  Log out of a container registry.
| `podman logs`        |  Display the logs of one or more containers.
| `podman machine`     |  Manage Podman's virtual machine
| `podman manifest`    |  Create   and manipulate manifest lists and image indexes.
| `podman mount`       |  Mount a working container's root filesystem.
| `podman network`     |  Manage Podman networks.
| `podman pause`       |  Pause one or more containers.
| `podman kube`        |  Play containers,  pods or volumes based on a structured input file.
| `podman pod`         |  Management tool for groups of containers, called pods.
| `podman port`        |  List port mappings for a  container.
| `podman ps`          |  Print out information about containers.
| `podman pull`        |  Pull an image from a registry.
| `podman push`        |  Push an image,  manifest list or image index from local storage to elsewhere. 
| `podman rename`      |  Rename an existing container.
| `podman restart`     |  Restart one or more containers.
| `podman rm`          |  Remove one or more containers.
| `podman rmi`         |  Remove one or more locally stored images. 
| `podman run`         |  Run a command in a new container.
| `podman save`        |  Save image(s) to an archive.
| `podman search`      |  Search a registry for an image.
| `podman secret`      |  Manage podman secrets.
| `podman start`       |  Start one or more containers.
| `podman stats`       |  Display a live stream of one or more container's resource usage statistics. 
| `podman stop`        |  Stop one or more running containers.
| `podman system`      |  Manage podman.
| `podman tag`         |  Add an additional name to a local image.
| `podman top`         |  Display the running processes of a container.
| `podman unmount`     |  Unmount a working container's root filesystem.
| `podman unpause`     |  Unpause one or more containers. 
| `podman unshare`     |  Run a command inside of a modified user namespace.
| `podman untag`       |  Remove one or more names from a locally-stored image.
| `podman update`      |  Update the cgroup configuration of a given container.
| `podman version`     |  Display the Podman version information.
| `podman volume`      |  Simple management tool for volumes.
| `podman wait`        |  Wait on one or more containers to stop and print their exit codes.


## Managing Image Storage with Podman
Podman images are stored locally after being pulled from a registry
* `/var/lib/containers/storage/`: The default storage location for images.  

To check Podman's active storage location:
```bash
podman info --format "{{.Store.GraphRoot}}"
```

### Podman Storage Configuration File
[Source: Oracle](https://docs.oracle.com/en/operating-systems/oracle-linux/podman/podman-ConfiguringStorageforPodman.html)  

You can configure how Podman stores images and containers by editing the `storage.conf`
configuration file.  

* `/etc/containers/storage.conf`: The location for the storage configuration file.  
* `$CONTAINERS_STORAGE_CONF`: An environment variable that points to the storage
  configuration file.  
    * This is not usually set by default.
    * Set it yourself to specify a custom config file.  

The storage file will look something like:
```ini
[storage]
  driver = "overlay"
  #runroot = "/run/user/1000"
  runroot = "/var/run/containers/storage"
  graphroot = "/var/lib/containers/storage"
  [storage.options]
    size = ""
    remap-uids = ""
    remap-gids = ""
    ignore_chown_errors = ""
    remap-user = ""
    remap-group = ""
    mount_program = "/usr/bin/fuse-overlayfs"
    mountopt = ""
    [storage.options.thinpool]
      autoextend_percent = ""
      autoextend_threshold = ""
      basesize = ""
      blocksize = ""
      directlvm_device = ""
      directlvm_device_force = ""
      fs = ""
      log_level = ""
      min_free_space = ""
      mkfsarg = ""
      mountopt = ""
      use_deferred_deletion = ""
      use_deferred_removal = ""
      xfs_nospace_max_retries = ""
```
* `driver`: The storage driver, used to define how images and containers are stored.  
    * With Podman, `overlay` defaults to `overlay2` (not Docker).
* `graphroot`: The default location where images are stored.  
    * You can change this to a different directory if you want to store images on a
      separate filesystem or disk.  
* `runroot`: The default storage directory for writable content inside a container.  
    * Defaults to `/var/run/containers/storage` for root users.  


### Directory Structure in `/varlib/containers/storage`
The `/var/lib/contianers/storage/` directory usually contains:
* Image layers and metadata, stored under subdirectories like `overlay` if you're
  using the overlay storage driver, which is specified in 
  the [configuration file](#podman-storage-configuration-file).  
    * `overlay/`: Contains overlay layers for each image, making up the filesystem
      for each container
    * `overlay-containers/`: Stores metadata and configuration for each container.  
    * `overlay-images/`: Stores metadata for each image, including image layers.  








