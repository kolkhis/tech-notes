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



## Cloning a Project with Submodules

When you clone a project that contains submodules, it will not populate those
submodule directories by default.  
```bash
git clone git@github.com:me/my-repo.git
```
If we look at the `repo-name` submodule [that we added earlier](#adding-a-submodule),
we can see if we have the files:
```bash
ls -alh ./my-repo/repo-name
```
Empty!

However, you can use the `--recurse-submodules` option when cloning to populate the
submodule.  
```bash
git clone --recurse-submodules git@github.com:me/my-repo.git
```
This will populate any and all submodules nested inside the project.  

---

If you've already cloned the repository but you forgot to use `--recurse-submodules`,
you can use `git submodule update` with `--init` and `--recursive` to populate the
submodules:  
```bash
git submodule update --init --recursive
```

This is identical to running:

```bash
git submodule init
git submodule update
```

- `git submodule init`: Initialize your local configuration file.  
- `git submodule update`: Fetch all the data from that project and check out the 
  appropriate commit listed in the parent project.  


