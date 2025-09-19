# `mkdocs`

These are notes on `mkdocs` from deploying a `mkdocs` site for my notes.  

`mkdocs` is a Python-based tool used to build static websites, geared towards
technical documentation.  


## Setting up MkDocs

These are setup notes for a MkDocs website.  

1. For local testing, use a virtual environment.  
   ```bash
   sudo apt-get install -y python3.10-venv  # to get the venv module
   sudo apt-get install -y python3.10-venv --fix-missing  # if install doesn't work
   ```
    - This is a Debian-based install. For RedHat-based distros, the `venv`
      module *should* be available as long as `python3` is installed.  
      ```bash
      sudo dnf install -y python3
      ```

1. Once the Python `venv` module is installed, create the virtual environment
   and activate it by sourcing the `venv/bin/activate` script.  
   ```bash
   cd ~/tech-notes
   python3 -m venv venv
   . venv/bin/activate
   ```

1. Verify you're in the virtual environment.  
   ```bash
   type python3
   # /home/kolkhis/tech-notes/venv/bin/python3
   ```

1. Install `mkdocs` and a theme for `mkdocs`.  
   ```bash
   pip install mkdocs mkdocs-material
   ```

1. Initialize the `mkdocs` project.  
   ```bash
   mkdocs new .
   ```
    - This initializes a new mkdocs project in the current directory (`.`).  
    - It creates a baseline `mkdocs.yml` file and a `docs/` directory with an
      `index.md` file.  

1. Add any markdown files you want to serve via the docs site into the `docs/`
   directory.  
   ```bash
   cp -r *.md docs/
   ```

1. Add all files to the `mkdocs.yml` file in the `nav` section to serve them.  
   ```yaml
   site_name: MyDocs
   nav:
     - Home: index.md
     - Other Page: other-file.md
   ```
    - See: <https://www.mkdocs.org/getting-started/#adding-pages>


## MkDocs Project Structure

In the root of the repo, you need a `docs/` directory.  
You also need a `mkdocs.yml` file in the repo root.  

The directory structure of my notes directory is fine for mkdocs, but it all needs to
be in the `docs/` directory instead of the root.  

## Resources
- <https://www.mkdocs.org/getting-started/#getting-started-with-mkdocs>
- <https://squidfunk.github.io/mkdocs-material/>
- <https://squidfunk.github.io/mkdocs-material/reference/icons-emojis/>

