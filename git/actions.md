# GitHub Actions
GitHub Actions is GitHub's integrated CI/CD pipeline.  
Using Actions, you can set up automated builds and deployments every time a new
commit is pushed to the repository.  

## Checkout

- <https://github.com/actions/checkout>

The `checkout` action pulls the contents of the repository so that it is available
inside the action.  

Without using `checkout`, the action doesn't have access to any of the files in the
repository.  

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
```

- `actions/checkout@v4`
    - This checks out the entire repository at the latest commit of the branch it's
      being called from.  

This action is required for **any** workflow that references or uses files 
inside the repository.  

> **Note**: If your repository contains submodules that you need access to inside the
> GitHub Action workflow, you also need to include:
> ```yaml
> - uses: actions/checkout@v4
>   with:
>     submodules: recursive
> ```
> This will populate any submodules in your repository.  


## Caching Dependencies
GitHub Actions allows for caching dependencies to help speed up deployments.  

An example, caching Rust/mdbook:
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: rust:1.74
    env:
      MDBOOK_VERSION: 0.4.36
    steps:
      - uses: actions/checkout@v4

      - name: Cache the cargo registry
        uses: actions/cache@v3  # This tells it that we're uses the caching action
        with:
          path: |
            ~/.cargo/registry
            ~/.cargo/git
            target
          key: cargo-${{ runner.os }}-${{ hashFiles('**/Cargo.lock') )}}
          restore-keys: cargo-${{ runner.os }}-
```

* The caching step here is the one that uses `actions/cache@v3`.  
    - `actions/cache@v3` is used to save and restore dependencies from previous builds.
    - When a workflow runs, it checks if a cache exists based on the cache key.  
    - If a cache hit occurs, the dependencies are restored instead of downloading
      them again.  
    - If there's a cache miss, dependencies are instealled and the cache is saved for
      future builds.  
* The `path` defines what should be cached.   
    - `~/.cargo/registry`: Stores downloaded crates.  
    - `~/.cargo/git`: Stores git dependencies (some rust crates come from github
      instead of crates.io).  
    - `target`: Stores compiled binaries and intermediate build files. 
* The `key` is the unique identifier for the cache. It ensures that the cache is only restored when dependencies haven't changed. 
    - `runner.os` resolves to `linux` (or `windows`/`macos`).
        - So the key here will look like `cargo-linux-<hash>`.  
* The `restore-keys` is used if an exact match for the `key` isn't found. It will try
  a partial match using `restore-keys`.  
    - So, the first part of the `key` is used.
      Ex:
      ```bash
      cargo-linux-a1b2c3d4 # Exact match found -- cache is used
      cargo-linux-         # No exact match -- uses closest match
      # No match -- build starts fresh
      ```


## Artifacts
Artifacts in GitHub Actions are files that are generated during the workflow that can
be shared between jobs.  

An artifact is a saved file or directory produced during the build.  
These files can be compiled binaries, logs, documentation, etc..

Artifacts are stored in GitHub Actions and can be downloaded manually or used in
later steps in the workflow.  

Another example from an mdbook automatic deployment:
```yaml
jobs:
  
  build:
  #...
    - name: Upload articats
      uses: actions/upload-pages-artifact@v3
      with: 
        path: ./book
```
This uploads files in the `book` directory (where `mdbook build` outputs the files)
as artifacts.  
This allows the `deploy` job to retrieve the built book.  


## Getting Job Steps Output (using Conditions)
Conditions in GitHub Actions can be given with the `if` key.  

Similar to Ansible, you can access the output of a job step.
Though, unlike Ansible, you don't need to `register` the output to access it.  

To use the output of a step in a conditional statement, give it an ID and reference
the ID inside the conditional.  

An example, checking the output of a caching step in order to see if a match was made:
```yaml
jobs:
  build:
    steps:
      # ...
      - name: Cache mdbook binary
        id: cache-mdbook
        uses: actions/cache@v3
        with:
          path: ~/.cargo/bin/mdbook
          key: mdbook-${{ env.MDBOOK_VERSION }}-${{ runner.os }}
          restore-keys: mdbook-
      - name: Install mdBook
        if: steps.cache-mdbook.outputs.cache-hit != 'true'
        run: cargo install --version ${MDBOOK_VERSION} mdbook
```

This accesses the output of the step with the `cache-mdbook` ID.  
This way, `mdBook` will only be installed if there was no cache hit.  

It's important to cache **before** the actual install step. That way you can check
for it before installing it.  

```yaml
```
