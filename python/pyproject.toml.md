### Contents of `pyproject.toml`

The `pyproject.toml` file is used for packaging and dependency management.  
It's part of the newer Python packaging standard (PEP 518, PEP 621).  
Here's what it typically includes:


1. **Project Metadata**:
    * Basic info like project name, version, description, authors, and license.
    * Example:
      ```bash
      [project]
      name = "example-project"
      version = "0.1.0"
      description = "An example project"
      authors = ["Your Name <you@example.com>"]
      license = "MIT"
      ```

2. **Dependencies**:
    * Direct dependencies required to run your project.
    * Example:
      ```toml
      [project.dependencies]
      flask = "^1.1.2"
      requests = "^2.25.1"
      ```

3. **Development Dependencies**:
    * Dependencies needed for development, such as testing libraries, but not for running the project.
    * Example:
      ```toml
      [project.dev-dependencies]
      pytest = "^6.2.1"
      ```

4. **Build System Requirements**:
    * Specifies the build backend and any requirements for building the project.
    * Example:
      ```toml
      [build-system]
      requires = ["setuptools", "wheel"]
      build-backend = "setuptools.build_meta"
      ```

5. **Other Configurations**:
    * Additional configurations like tool-specific settings for 
      linters, formatters, etc.

