
# Deploy Docker Containers with Terraform



## Table of Contents
* [Deploy Docker Containers with Terraform](#deploy-docker-containers-with-terraform) 
* [Setting Up Terraform](#setting-up-terraform) 
* [Project Setup](#project-setup) 
    * [Check that containerd is running and exposed on your system](#check-that-containerd-is-running-and-exposed-on-your-system) 
    * [Check that Terraform is installed on your system](#check-that-terraform-is-installed-on-your-system) 
    * [Make a Directory for your Terraform Project Files](#make-a-directory-for-your-terraform-project-files) 
    * [Make sure there are no other Docker containers running](#make-sure-there-are-no-other-docker-containers-running) 
* [Creating a Deployment](#creating-a-deployment) 
* [Deploy 3 containers that are bound internally on port 80 and externally use 8080, 8081, and 8082.](#deploy-3-containers-that-are-bound-internally-on-port-80-and-externally-use-8080-8081-and-8082) 
* [tl;dr](#tl;dr) 



## Setting Up Terraform
Your team has decided to use Terraform and deploy containers in an infrastructure as code manner.
Verify that `containerd` is running and that Terraform is installed on your system.

Hint:

* `sudo systemctl status containerd`
* The build infrastructure[docs](https://developer.hashicorp.com/terraform/tutorials/docker-get-started/docker-build)


---

## Project Setup
Make sure all the prerequisites are met.
* `containerd` is running
* `terraform` is installed


### Check that containerd is running and exposed on your system
```bash
systemctl status containerd --no-pager
ss -ntulp | grep -i containerd
```

### Check that Terraform is installed on your system
```bash
which terraform
terraform version
```

### Make a Directory for your Terraform Project Files
```bash
sudo mkdir /root/learn-terraform-docker-container
cd /root/learn-terraform-docker-container/
```

### Make sure there are no other Docker containers running
```bash
docker ps -a
docker images
```

---

## Creating a Deployment
Let's create the first deployment of Terraform in our environment.

* Create a Terraform configuration for running `nginx` on port 8000 on your system.
* Verify that you can see the running container.
* View your `terraform.tfstate` file to see what Terraform tracks in a configuration deployment.


---

* Make a `main.tf` file in the directory
  ```bash
  touch main.tf
  ```

* Add a default configuration for the terraform project
  ```tf
  terraform {
    required_providers {
      docker = {
        source  = "kreuzwerker/docker"
        version = "~> 2.13.0"
      }
    }
  }
   
  provider "docker" {}
  
  resource "docker_image" "nginx" {
    name         = "nginx:latest"
    keep_locally = false
  }
   
  resource "docker_container" "nginx" {
    image = docker_image.nginx.latest
    name  = "tutorial"
    ports {
      internal = 80
      external = 8000
    }
  }
  ```

* Make sure the Terraform configuration is well formatted and validated.
  ```bash
  terraform fmt
  terraform validate
  ```

We will see an error here.
This is because the validate is looking to see if we've done an `init` and pulled down the provider.
That is happening in the next step.

* Before we can deploy with Terraform we need to initialize and download all providers.
  ```bash
  terraform init
  ```

* Let's check the system to see all the files that have been created
  ```bash
  ls -al
  ```

* Let's deploy our resources
  ```bash
  terraform apply --auto-approve
  ```

* Let's verify that we have a working container
  ```bash
  docker images
  docker ps
  curl 127.0.0.1:8000
  ```

* Look at the `terraform.tfstate` file to see all the objects that terraform is tracking in the deployment.
  ```bash
  cat terraform.tfstate
  ```
  WARNING: The `terraform.tfstate` file should never be edited by hand, only 
  terraform should edit that file.

---

Your team is very impressed that you were able to deploy one container with Terraform and Docker.
Now they want you to deploy multiple containers for different ports on the system.

## Deploy 3 Containers
Deploy 3 containers that are bound internally on port 80 and
externally use 8080, 8081, and 8082.

* Start by destroying our old Terraform configuration.
  ```bash
  terraform destroy --auto-approve
  ```

* Then edit for our new configuration.
  ```bash
  vi main.tf
  ```
  Set the configuration to look like this:
  ```terraform
  terraform {
    required_providers {
      docker = {
        source  = "kreuzwerker/docker"
        version = "~> 2.13.0"
      }
    }
  }
  
  provider "docker" {}
  
  resource "docker_image" "nginx" {
    name         = "nginx:latest"
    keep_locally = false
  }
  
  resource "docker_container" "nginx8080" {
    image = docker_image.nginx.latest
    name  = "nginx8080"
    ports {
      internal = 80
      external = 8080
    }
  }
  
  resource "docker_container" "nginx8081" {
    image = docker_image.nginx.latest
    name  = "nginx8081"
    ports {
      internal = 80
      external = 8081
    }
  }
  
  resource "docker_container" "nginx8082" {
    image = docker_image.nginx.latest
    name  = "nginx8082"
    ports {
      internal = 80
      external = 8082
    }
  }
  ```

* Make sure the Terraform configuration is well formatted and validated.
  ```bash
  terraform fmt
  terraform validate
  ```

* Deploy our resources
  ```bash
  terraform apply --auto-approve
  ```

* Verify that all the containers are working.
  ```bash
  docker images
  docker ps
  curl 127.0.0.1:8080
  sleep 2
  curl 127.0.0.1:8081
  sleep 2
  curl 127.0.0.1:8082
  ```






## tl;dr

* Check that `containerd` is running and exposed (i.e., listening) on your system.
  ```bash
  sudo systemctl status containerd --no-pager
  ss -ntulp | grep -i containerd
  ```
* Check that `terraform` is installed.
  ```bash
  which terraform
  terraform version
  ```
* Create a directory named `learn-terraform-docker-container`.
  ```bash
  mkdir learn-terraform-docker-container
  ```
* Change into the directory.
  ```bash
  cd learn-terraform-docker-container
  ```
* Create a `main.tf` file to define your infrastructure. 
  ```bash
  touch main.tf
  ```

* Set a configuration in `main.tf`
  ```tf
  terraform {
    required_providers {
      docker = {
        source = "kreuzwerker/docker"
        version = "~> 3.0.1"
      }
    }
  }
  
  provider "docker" {}
  
  resource "docker_image" "nginx" {
    name         = "nginx:latest"
    keep_locally = false
  }
  
  resource "docker_container" "nginx" {
    image = docker_image.nginx.image_id
    name  = "tutorial"
    ports {
      internal = 80
      external = 8000
    }
  }  
  ```


