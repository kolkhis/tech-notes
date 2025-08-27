# Git Submodules

Git submodules are a way to nest repositories within other repositories.  

## Adding a Submodule

Use the `git submodule add` command to add a submodule to an existing repo.  
```bash
cd myrepo
git submodule add [URL]
```
The `[URL]` is the location of the repository to be added as a submodule.  

For example, adding a submodule via SSH destination:
```bash
git submodule add git@github.com:username/repo-name.git
```
This does a couple of things:

- Adds a directory for the submodule.  

    - The submodule is named after the repo name, and by default is put in a
      self-named directory where you ran the command.  
    - If you ran the `git submodule add` command in the root directory of your `my-repo` 
      repository, the submodule will be in `my-repo/repo-name`.  

- Adds a `.gitmodules` file to the root of the repository.  

    - This is an INI-style file:
      ```ini
      [submodule "repo-name"]
          path = repo-name
          url = git@github.com:username/repo-name.git
      ```

The submodule will store a commit hash. This is the commit at which the submodule's 
files will be in sync with.  




