
# Miscellaneous Python Notes

## Python HTTP Server

To spin up an http server, you can use `python3 -m http.server` to serve a directory.


## MkDocs Static Website

Requirements for `mkdocs`:
* mkdocs
* mkdocs-awesome-pages-plugin
* mkdocs-material
* mkdocs-git-revision-date-localized-plugin
* markdown-emdash
* git-revision-date-localized
* python-markdown
* mdx_emdash


```bash
mkdocs serve -a 0.0.0.0:3000
```
Produces a static site

## Containerize the application
To safely share with others, you can containerize the application.
Use `podman` or `docker` to build the image:
```Dockerfile
# Use the Python version you need
#FROM python:3.9-slim 
FROM python:3.11

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the current directory into the container at the WORKDIR
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world, for web apps
EXPOSE 80

# Set environment variables
ENV NAME World
ENV PATH /usr/src/app

# Run the app when the container launches
RUN ["python3", "./app.py"]
```
Then build the image
```bash
podman build -t python-app .
```
and run it
```bash
podman run -p 8080:80 python-app
```

