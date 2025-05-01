# `mkdocs`

These are notes on `mkdocs` from deploying a `mkdocs` site for my notes.  

`mkdocs` is a Python-based tool used to build static websites, geared towards
technical documentation.  


## Setting up MkDocs

```bash
MKDOCS_DIR='~/tech-notes'
```
1. If hosting locally, use a virtual environment.  
   ```bash
   sudo apt-get install python3.10-venv  # to get the venv module
   sudo apt-get install python3.10-venv --fix-missing  # if install doesn't work
   python3 -m venv venv
   ```

1. Install `mkdocs` and a theme for `mkdocs`.  
   ```bash
   pip install mkdocs mkdocs-material
   ```

1. Initialize the `mkdocs` project.  
   ```bash
   mkdocs new tech-notes
   cd tech-notes
   ```

1. 
