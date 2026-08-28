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

This will start a PostgreSQL container, running on a lightweight Alpine image.

The volumes defined match the `source:destination` pattern, where the `source`
is on the host machine and will be mounted into `destination` inside the
container.

- `myapp_pgdata:/var/lib/postgresql/data`
    - This defines the **named volume** `myapp_pgdata`, and points to where the 
      volume should be mounted inside the container (`/var/lib/postgresql/data`).  
    - This is a **persistent volume definition**, since it is declared at the
      bottom:  
      ```yaml
      volumes:
        myapp_pgdata:
      ```
      <!-- TODO: What would happen if this were not declared at the bottom? -->
    - Podman will create the volume if it doesn't exist, and this will allow
      data to persist when restarting the container.  
    - View the volumes that Podman manages with:
      ```bash
      podman volume ls # may be named `myapp_myapp_pgdata`
      ```  
      Or inspect its details:
      ```bash
      podman volume inspect myapp_myapp_pgdata
      ```

- `./db/schema.sql:/docker-entrypoint-initdb.d/01-schema.sql:ro`
    - Defines the SQL schema as listed in the local `./db/schema.sql` file.  
    - Mounts this to `/docker-entrypoint-initdb.d/01-schema.sql` inside the
      container.  
    - Contains `:ro` at the end, defining it as a **read-only** mount.  
    - This is usually called a bind mount rather than a named volume.  


#### Named Volumes vs. Bind Mounts

- Using a named volume, the container runtime manages the storage.  
    - This is good for databases, application state, persistent runtime data, and
      data that would not normally be manually edited.  

- A bind mount is an actual file or directory on the host machine, not managed 
  by the container runtime.  
    - This is what is typically used for configuration files, source code for
      applications, init scripts, or other files that need to be manually edited.  

