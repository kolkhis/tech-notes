
# Lesson 1: Introduction to Containers

## What are Containers?

Containers are lightweight, standalone, and executable software packages that include everything needed to run a piece of software, including the code, runtime, libraries, and system tools.

## Why Use Containers?

* Isolation: Containers isolate the application, making it easier to manage dependencies.
* Portability: Containers can run anywhere, making it easier to move applications across environments.
* Scalability: Containers can be easily scaled up or down.

## Containerization vs Virtualization

* Virtual Machines: Run a full OS stack, more resource-intensive.
* Containers: Share the host OS, lightweight and faster.

## Practical Exercise: Install Docker on your homelab

Since you're running Ubuntu Server on your homelab, you can install Docker with the following commands:

```bash
sudo apt update
sudo apt install docker.io
sudo systemctl enable --now docker
```


* sudo apt update: Updates package lists.
* sudo apt install docker.io: Installs Docker.
* sudo systemctl enable --now docker: Enables and starts the Docker service.

## Homework

* Read about the history of containerization.
* Compare the performance of a containerized app vs a non-containerized app.

## Quiz

* What is a container?
* List two advantages of using containers.

