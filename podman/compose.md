# Podman Compose

Podman Compose is a tool that allows you to define and manage multi-container 
applications using Podman.

It is similar to Docker Compose but is designed to work with Podman. 

Podman is a **daemonless** container engine for developing, managing, and running 
OCI containers on a Linux system.


## Installation

The Podman Compose tool doesn't ship with Podman by default, so is must be
installed separately.  

Install it using pip (or other Python package manager):
```bash
pip install -U podman-compose
```

## Using Podman Compose

Podman Compose uses a YAML file to define the services, networks, and volumes 
for the application.

The default file name is `docker-compose.yml`, but a different 
file can be specified using the `-f` option.

It is fully compatible with Docker Compose, so the same
`docker-compose.yml` file can be used to define the application.

Once you have your `docker-compose.yml` file, simply use the following command
to start the container:
```bash
podman-compose up -d
```

## Example `docker-compose.yml` file

An example file that can be used to spin up a Postgres container:
```yaml
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: myapp
      POSTGRES_PASSWORD: myapp
      POSTGRES_DB: myapp
    ports:
      - "5432:5432"
    volumes:
      - myapp_pgdata:/var/lib/postgresql/data
      - ./db/schema.sql:/docker-entrypoint-initdb.d/01-schema.sql:ro

volumes:
  myapp_pgdata:
```



