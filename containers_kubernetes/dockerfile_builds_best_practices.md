# Dockerfiles and Builds Best Practices

* [source: docker docs](https://docs.docker.com/build/building/best-practices/)

## Table of Contents
* [Use multi-stage builds](#use-multi-stage-builds) 
* [Create reusable stages](#create-reusable-stages) 
* [Choose the right base image to secure it.](#choose-the-right-base-image-to-secure-it) 
    * [Using a smaller base image to run an application can be more secure](#using-a-smaller-base-image-to-run-an-application-can-be-more-secure) 
    * [Running applications as root inside a container can be less secure](#running-applications-as-root-inside-a-container-can-be-less-secure) 
* [Every container works with layers](#every-container-works-with-layers) 
* [Rebuild your images often](#rebuild-your-images-often) 
* [Exclude with `.dockerignore`](#exclude-with-dockerignore) 
* [Create ephemeral containers](#create-ephemeral-containers) 
* [Decouple applications.](#decouple-applications) 
* [Sort multi-line args.](#sort-multi-line-args) 
* [Leverage the build cache](#leverage-the-build-cache) 
* [Pin base image versions](#pin-base-image-versions) 
* [Build and test images in CI (Continuous Integration)](#build-and-test-images-in-ci-continuous-integration) 
* [Resources](#resources) 

## Use multi-stage builds
Multi-stage builds are the practice of splitting your Dockerfile instructions into
disctinct stages to make sure that the reulting output only contains the files that
are essential to running the application.  

## Create reusable stages
If you have multiple images that have a lot in common, create a "reusable stage" that
includes the shared components. Base your unique stages on that.  
The common stage only needs to be built once. Any images that use the common stage
will use memory on the host system more efficiently and load more quickly.  

## Choose the right base image to secure it.
Use a minimal base image that meets your requirements.  
A small base image is portable, downloads quickly, and shrinks the size of your image
and minimizes the number of vulnerabilities introduced through dependencies.  

Consider using two types of base image: One for building and unit testing, and
another (slimmer) image for production.  

In late stages of development, your prod image may not require build tools (like
compilers, build systems, debugging tools, etc.). A small image with minimal
dependencies can lower the attack surface considerably.  

### Using a smaller base image to run an application can be more secure
```Dockerfile
FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y golang-go
COPY app.go .
RUN CGO_ENABLED=0 go build app.go
FROM alpine 
COPY --from=0 /app .
CMD ["./app"]
```
This uses ubuntu to set up the environment then alpine to run the application.  

### Running applications as root inside a container can be less secure
```Dockerfile
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y golang-go=2:1.13~1ubuntu2
COPY app.go .
RUN CGO_ENABLED=0 go build app.go
FROM alpine:3.12.0
RUN addgroup -S appgroup && adduser -S appuser -G appgroup -h /home/appuser
COPY --from=0 /app /home/appuser/
USER appuser
CMD ["/home/appuser/app"]
```
This creates a new user and group, which are then used to run the app.  
The app isn't run as `root`, so it can minimize damage if an attacker manages to do
some arbitrary remote code execution.  

## Every container works with layers
Every `FROM`, `COPY`, `RUN`, and `CMD` will create one layer.  
Try to use the minimum amount of layers for images.  
E.g., If you can do the same thing in 2 `RUN` commands as 1 `RUN` command, use 1.  


## Rebuild your images often
Docker images are immutable.  
Building an image is taking a snapshot of that image at that moment.  
This snapshot includes any base images, libraries, or other software you use in your
build.  
Keep your images up to date by rebuilding ofte, with updated dependencies. . 

To make sure you're getting the latest versions of dependencies in a build, use the
`--no-cache` option (for both Docker and Podman).  


## Exclude with `.dockerignore`
You can use a `.dockerignore` file to exclude files not relevant to the build without
modifying the source repo.  
This file supports patterns, just like `.gitignore`.  
```gitignore
*.md
*.txt
__pycache__/
```
* [more info](https://docs.docker.com/build/concepts/context/#dockerignore-files)


## Create ephemeral containers
Images defined by your Dockerfiles should generate containers that are as ephemeral
as possible.  
The container should be able to be stopped, destroyed, and rebuilt and replaced with
an absolute minimum amount of setup and configuration.  

* Don't install unnecessary packages.  

## Decouple applications.
Each container should only have one concern. Decoupling apps into multiple containers
makes it easier to scale out and reuse containers.  


## Sort multi-line args.
Sort multi-line arguments alphanumerically. This makes maintenance easier. 
Sorting arguments helps to avoid duplication of packages and makes the list much easier to update. 
Adding spaces before backslashes `\` helps as well.
```Dockerfile
RUN apt-get update && apt-get install -y \
  bzr \
  cvs \
  git \
  mercurial \
  subversion \
  && rm -rf /var/lib/apt/lists/*
```

## Leverage the build cache
TODO: Understand how to [build cache](https://docs.docker.com/build/cache/) works

## Pin base image versions
Image tags are mutable. So, publishers can update a tag to point to a new image.  
This will let you rebuild your image and get the latest version of a base image.  
E.g., if you specify `FROM alpine:3.19`, the `3.19` resolves to the latest patch for
`3.19`.  
```Dockerfile
FROM alpine:3.19
```
This might point to `3.19.1`, and 3 months later it might point to `3.19.4`.  
Downside to this, it may potentially result in some breaking changes.  

You can specify a `digest` to use, which will represent a specific image version.  
```Dockerfile
FROM alpine:3.19@sha256:13b7e62e8df80264dbb747995705a986aa530415763a6c58f84a3ca8af9a5bcd
```
Using the `digest` method, your builds will all use the pinned image version, `13b7e62e8df80264dbb747995705a986aa530415763a6c58f84a3ca8af9a5bcd`.  

Downside to this: You're opting out of automated security fixes.  

## Build and test images in CI (Continuous Integration)
When adding a git commit or pull request, use Github Actions (or another CI/CD
pipeline) to automatically build and tag a Docker image and test it.  


---

## Resources
* [Dockerfile instructions best practices](https://docs.docker.com/build/building/best-practices/#dockerfile-instructions)
* [Dockerfile instructions reference](https://docs.docker.com/reference/dockerfile/)



