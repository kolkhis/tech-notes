# podman

Podman is a container engine for developing, managing, and running OCI Containers on a Linux System.
OCI (Open Container Initiative) Containers are a kind of package that encapsulate your application and all its dependencies.


## Table of Contents
* [Podman Cheatsheet](#podman-cheatsheet) 
* [Building a Container from a Dockerfile](#building-a-container-from-a-dockerfile) 
* [Example of Running a Container with Podman (Apache HTTP Server)](#example-of-running-a-container-with-podman-apache-http-server) 
* [Stopping a Container](#stopping-a-container) 
* [Avoiding Port Conflicts](#avoiding-port-conflicts) 
* [Pods vs. Containers](#pods-vs-containers) 
    * [Containers](#containers) 
    * [Pods](#pods) 
* [List of Podman Commands](#list-of-podman-commands) 
* [Managing Image Storage with Podman](#managing-image-storage-with-podman) 
    * [Podman Storage Configuration File](#podman-storage-configuration-file) 
    * [Directory Structure in `/varlib/containers/storage`](#directory-structure-in-varlibcontainersstorage) 
* [Binding Local Storage to a Container Directory](#binding-local-storage-to-a-container-directory) 
    * [Container Volume Options](#container-volume-options) 
    * [Volume Mount Option Examples](#volume-mount-option-examples) 
        * [Basic read-only bind mount](#basic-read-only-bind-mount) 
        * [Mounting with Overlay option](#mounting-with-overlay-option) 
        * [Mount with SELinux Contexts](#mount-with-selinux-contexts) 
        * [Bind mount with `nosuid` and `noexec` options](#bind-mount-with-nosuid-and-noexec-options) 
* [Named Container Volumes and Anonymous Volumes](#named-container-volumes-and-anonymous-volumes) 
* [Podman Environment Variables](#podman-environment-variables) 
* [Removing Images and Anonymous Volumes after Container Exits](#removing-images-and-anonymous-volumes-after-container-exits) 
* [Limitations of Containers](#limitations-of-containers) 


## Podman Cheatsheet
```bash
cd /var/lib/containers/storage/       # Where container images are stored for root
cd ~/.local/share/containers/storage/ # The default image storage location for normal users
vi /var/lib/containers/storage.conf   # Edit the storage configuration file.  

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
podman run --name 'name' *image* # Run container with a specific name, without, the name is random
podman run -p 'host_port':*container_port* *image*  # Map ports between host and container
podman run -v 'host_path':*container_path* *image*  # Mount a host directory in the container

# Image Management
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
* [Dockerfile instructions reference](https://docs.docker.com/reference/dockerfile/)


2. Build the container image from the Dockerfile.  
   ```bash
   podman build -t kol_hello .
   # or, to add a tag
   podman build -t kol_hello:latest .
   ```
    * `-t kol_hello`: Specify a name and tag for the image. The tag is optional.  
    * `.`: Specifies the path to the directory containing the Dockerfile.  


## Example of Running a Container with Podman (Apache HTTP Server)
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
| `podman exec`        |  Execute a command in a running container.
| `podman export`      |  Export a container's filesystem contents as a tar archive.
| `podman generate`    |  Generate structured data based on containers, pods or volumes.
| `podman healthcheck` |  Manage healthchecks for containers
| `podman history`     |  Show the history of an image.
| `podman image`       |  Manage images.
| `podman images`      |  List images in local storage.
| `podman import`      |  Import a tarball and save it as a filesystem image.
| `podman info`        |  Display Podman related system information. 
| `podman init`        |  Initialize one or more containers
| `podman inspect`     |  Display a container, image, volume, network, or pod's configuration.
| `podman kill`        |  Kill the main process in one or more containers.
| `podman load`        |  Load image(s)  from a tar archive into container storage.
| `podman login`       |  Log in to a container registry.
| `podman logout`      |  Log out of a container registry.
| `podman logs`        |  Display the logs of one or more containers.
| `podman machine`     |  Manage Podman's virtual machine
| `podman manifest`    |  Create and manipulate manifest lists and image indexes.
| `podman mount`       |  Mount a working container's root filesystem.
| `podman network`     |  Manage Podman networks.
| `podman pause`       |  Pause one or more containers.
| `podman kube`        |  Play containers, pods or volumes based on a structured input file.
| `podman pod`         |  Management tool for groups of containers, called pods.
| `podman port`        |  List port mappings for a container.
| `podman ps`          |  Print out information about containers.
| `podman pull`        |  Pull an image from a registry.
| `podman push`        |  Push an image, manifest list or image index from local storage to elsewhere. 
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
* `/var/lib/containers/storage/`: The default image storage location for UID 0
  (the root user).  
* `$HOME/.local/share/containers/storage`: The default image storage location for all
  other users.  

To check Podman's active storage location:
```bash
podman info --format "{{.Store.GraphRoot}}"
```

To override the default storage location:
```bash
# Either use --root with podman:
podman --root /path/to/images run...
```
Or, change the storage `graphroot` in `/etc/containers/storage.conf` (the [podman storage config file](#podman-storage-configuration-file)).  

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


## Binding Local Storage to a Container Directory
You can use `-v` to bind a local directory (or named container volume) to a directory inside a container.  

Syntax:
```plaintext
--volume, -v=[[SOURCE-VOLUME|HOST-DIR:]CONTAINER-DIR[:OPTIONS]]
```
* `SOURCE-VOLUME|HOST-DIR`: Optional. The source directory on the host machine or
  [named container volume](#named-container-volumes-and-anonymous-volumes).  
    * Must be a path on the host or the name of a named volume.  
    * You can also specify a container volume name instead of a directory. 
        * If you specify a named volume, it will be created if it doesn't exist.  
        * Volumes will be in `/var/lib/containers/storage/volumes`
    * Host paths are allowed to be absolute or relative.
        * Relative paths are resolved relative to the directory Podman is run in.
    * Any source that does not begin with a `.` or `/` is treated as the name of a named volume.
* `CONTAINER-DIR`: The directory inside the container.  
    * The `SOURCE-VOLUME/HOST-DIR` is mounted into the container at this directory.
    * The `CONTAINER-DIR` must be an absolute path.
* `OPTIONS`: Options for the mount. 
    * This is a comma-separated list of options (see below) 

---

* Mount multiple volumes into a container by adding more `-v` options.
* If no local storage is given, Podman creates an [anonymous volume](#named-container-volumes-and-anonymous-volumes) with a random name.

---

 Create a bind mount.
If -v /HOST-DIR:/CONTAINER-DIR is specified, Podman bind mounts /HOST-DIR from the host into /CONTAINER-DIR in the Podman container.
Similarly, -v SOURCE-VOLUME:/CONTAINER-DIR mounts the named volume from the host into the container.  
If no such named volume exists, Podman creates one.  

(Note when using the remote client, including Mac and Windows (excluding  WSL2)  machines,  the  volumes  are
mounted from the remote server, not necessarily the client machine.)

### Container Volume Options
The `OPTIONS` for `-v` is a comma-separated list.  
Available options:
* `rw|ro`
    * `rw`: Mounts the volume with read/write permissions (default).  
    * `ro`: Mounts the volume as read-only.  
* `z|Z`
    * `z`: Apply shared SELinux labels to the mount.
        * Allows the volume to be accessed by multiple containers that require shared access.  
    * `Z`: Apply a private SELinux label to the mount.
        * Makes it accessible only to the current container.  
      
* `[O]`: Enable the "OverlayFS" storage driver.  
    * Allows the "Overlay Storage Driver" to be used for the mount.
    * Useful when mountaing an overlay filesystem to improve performance in some scenarios
    * Using this requires the host directory to support the overlay filesystem.  
    * TODO: Find out what "OverlayFS"/"Overlay Storage Driver" is.  

* `[U]`: User namespace remapping
    * Automatically remaps UIDs and GIDs to match user namespaces if they're enabled.  
    * Useful for running containers with different user permissions than the host.  

* `[no]copy`
    * `copy`: Copies data from the container's original directory into the mount
      location on first use.   
    * `nocopy`: Skips copying data on first use.
        * Can improve performance on empty or new directories.  

* `[no]dev`
    * `dev`: Allows access to device files on the host within the mount.  
    * `nodev`: Restricts access to device files within the mount. 
        * Generally more secure.  

* `[no]exec`
    * `exec`: Allows execution of binaries on the host within the mount.
    * `noexec`: Prevents the execution of binaries from the mount.  
        * Generally more secure.  

* `[no]suid`
    * `suid`: Enables the `setuid` and `setgid` bits.  
        * These bits allow executables to run with elevated privileges.  
    * `nosuid`: Disables the `setuid` and `setgid` bits.
        * Generally more secure.  

* `[r]bind`
    * `bind`: Creates a simple bind mount that mirrors a host directory into the
      container, and reflects any changes on the host.  
    * `rbind` (recursibe bind): Binds the specified directory and all its subdirectories.  

* `[r]shared|[r]slave|[r]private[r]unbindable`: Defines mount propagation settings.
  Controls how changes within the mount are propgated between the host and container.  
    * `shared`: Changes in the mount point are propagated between the container and
      the host in both directoies.  
    * `slave`: Only changes on the host propagate to the container.  
    * `private`: No changes are propagated in either direction.  
    * `unbindable`: Marks the mount as unbindable. Prevents it from being mounted elsewhere.  
    * `r`: Makes any of the options above recursive, applying the setting to all subdirectories.  
* `idmap[=options]`
    * Sets ID mapping options. 
    * Allows you to specify how UIDs and GIDs are mapped betwee nthe host and
      container. 
    * Used when you need finer control over user and group access.  
    * `idmap=container:[user_name_in_container[:user_id_in_container]]`


### Volume Mount Option Examples
#### Basic read-only bind mount:
```bash
podman run -v /host/config:/app/config:ro myimage
```

#### Mounting with Overlay option:
```bash
podman run -v /host/data:/data:O myimage
```
Enables overlay.
Potentially improves performance in `/host/data` supports overlay storage.  

#### Mount with SELinux Contexts
```bash
podman run -v /shared/data:/container/data:z myimage
```

#### Bind mount with `nosuid` and `noexec` options
```bash
podman run -v /host/shared:/contianer/shared:nosuid,noexec myimage
```
This makes `/host/shared` available inside the contianer at /container/shared, but 
prevents the execution of binaries (`noexec`) from the mount, and disables `suid`
permissions (`nosuid`) permissions.
This improves security within the container.  


---

## Named Container Volumes and Anonymous Volumes
The actual storage location on the host machine: 
* `/var/lib/containers/storage/volumes` for Podman 
* `/var/lib/docker/volumes` for Docker

If you specify a name for `SOURCE-VOLUME`, Podman creates a new volume with that name
if it doesn't already exist.  

If you don't specify a name or path to mount to the container, Podman creates an
anonymous volume and mounts it to the container. 
This anonymous volume will have a random name and will be stored in the same place as
named volumes.  


---

## Podman Environment Variables

* `CONTAINERS_CONF`: Set default locations of `containers.conf` file
* `CONTAINERS_REGISTRIES_CONF`: Set default location of the `registries.conf` file.
* `CONTAINERS_STORAGE_CONF`: Set default location of the `storage.conf` file.
* `CONTAINER_CONNECTION`: Override default `--connection` value to access Podman service. Also enabled `--remote` option.
* `CONTAINER_HOST`: Set default `--url` value to access Podman service. Also enabled --remote option.
* `CONTAINER_SSHKEY`: Set default `--identity` path to ssh key file value used to access Podman service.
* `STORAGE_DRIVER`: Set default `--storage-driver` value.
* `STORAGE_OPTS`: Set default `--storage-opts` value.
* `TMPDIR`: Set the temporary storage location of downloaded container images. Podman defaults to use `/var/tmp`.

* `XDG_CONFIG_HOME`: In  Rootless mode, configuration files are read from `XDG_CONFIG_HOME` when specified, otherwise in the home directory of the user under `$HOME/.config/containers`.
* `XDG_DATA_HOME`: In Rootless mode, images are pulled under XDG_DATA_HOME when specified, otherwise in the home directory of the user under `$HOME/.local/share/containers/storage`.
* `XDG_RUNTIME_DIR`: In Rootless mode, temporary configuration data is stored in `${XDG_RUNTIME_DIR}/containers`.



## Removing Images and Anonymous Volumes after Container Exits
Remove images and anonymous volumes automatically using `podman run` with these flags:
* `--rm`: Automatically remove the container and any anonymous unnamed volume 
          associated with the container when it exits.
    * This is disabled by default.  

* `--rmi`: After the container exits, remove the image unless another container is using it. 
    * Implies `--rm` on  the  new container.
    * This is disabled by default.  

Volumes created with actual names are not anonymous. 
They are not removed by the `--rm` option or `podman rm --volumes`.

---

## Getting into a Running Container
`man://podman-exec`
Attach to a container:

If the container was started in detached mode (`podman run -d`), you can "attach"
to it. 

You can execute a command inside the container or start an interactive shell
session using `podman exec`.  
 
`podman exec` executes a command in a running container.

```bash
podman exec -it mycontainer bash
```
* `-i`: Keep STDIN open even if not attached.
    * This means that you will be able to type into the container, enabling
      interactive input.  
* `-t`: Allocate a pseudo-TTY (terminal interface). 
    * Creates a terminal-like session inside the container.  
    * This does the same as `-t` when running `podman run`.  
* `bash`: Specify the command to run.  
    * This can be any command, including shells, and you can specify arguments
      to the command.  

`podman attach` can also be used to attach to a running container

```bash
podman attach mycontainer
```
* This attaches to the container using the primary process that's already running
  inside the container.  
* Unlike the `exec` cmd, this does *not* start a new process in the container.  
* If the primary process does not output to a terminal, or `stdin` is not
  interactive, attaching may not be very useful.  
* Can be useful to monitor the output of the process running in a container.  
* So, unless the container is running a shell, you may want to use `exec` instead.  


## Pulling Images from Registries  
You can pull images with `podman pull IMAGE`.  
```bash
podman pull docker.io/library/python:3.11
```

If you have registries configured in `registries.conf`, you can pull using short names. 
```bash
cat /etc/containers/registries.conf
# This is the variable that contains a list of registries to pull from using short names
unqualified-search-registries = ["registry.access.redhat.com", "registry.redhat.io", "docker.io"]
```
It's suggested to always use the fully qualified name of the image in order to
protect against spoofing.  
 
This means specifying the link, the domain, image name, and tag (optionally, the
digest).  



