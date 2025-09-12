# The `gh` Tool

The `gh` tool is used to do anything and everything GitHub-related on 
the command line.  

## Getting Help

There's a lot of help text for `gh`.  

Run any gh command with `--help` to see usage, flags, and examples.  
```bash
gh --help
gh repo --help
gh repo create --help
gh issue create --help
```
You can also hit `<Tab><Tab>` (to trigger completion) to see available
subcommands along the way.  

In addition to the help text, each `gh` subcommand has its own `man` page.  
```bash
man gh-repo
man gh-repo-create
man gh-repo-sync
man gh-pr
man gh-pr-view
```

There's no shortage of technical documentation for the `gh` tool.  


## Authentication
After you first install `gh`, use the `gh auth login` command to set up
authentication.  

```bash
gh auth login
```
Go through the steps to login and you'll be able to use `gh` to manage 
your GitHub through the command line.  

## Repository Operations
You can use `gh` to perform a number of repo operations using the `repo`
subcommand.  


The `repo` subcommand also has a number of other subcommands.  

??? note "Where do changes happen?"
    Many of these commands affect the **remote repository** stored on GitHub, not
    necessarily your local repository.  
    Some of these commands (e.g., `clone`) will affect your local system.  

- `archive`: Archives a repository.  
- `clone`: Clone a repo to your local system (`user/repo-name`)
- `create`: Create a new repo on GitHub.  
- `delete`: Delete a repo on GitHub.  
- `edit`: Edit the description of a repository on GitHub.  
- `fork`: Create a fork of a repo on GitHub.  
- `list`: List repos owned by the user or organization.  
- `rename`: Rename a repository on GitHub.  
- `sync`: Sync a repository.  
    - By default, it syncs the local repository with the remote repository.  
- `view`: View a GitHub repostiory (description and `README.md`).  
    - Use `--web` to open the repo in a web browser (requires GUI).  

These subcommands are pretty self-explanatory for what they do.  

See `man gh-repo` for what they each do.  

### Cloning a Repository
Use the `gh repo clone` command to clone a GitHub repository locally.  

```bash
gh repo clone username/repo-name
```

You only have to specify the `username` and `repo-name`, separated by a slash, 
not the full `github.com` path.

### Creating a Repository
You can create a new repository on GitHub without opening your web browser with
`gh`.  

```bash
gh repo create
```

This will launch an interactive program that will let you configure your new
repository.  

If you don't want an interactive program, there are many options you can pass
for the repo's settings.  
```bash
gh repo create new-repo \
    --description "My new repo" \
    --public \
    --clone
```
This creates a new **public** repository on GitHub called `new-repo` with the
description `My new repo`, then clones it down to your local machine.  

---

If you already have a repository that you want to push up to GitHub, you can
specify `--source` for this.  

You can also specify what the `remote` will be called.  
```bash
gh repo create new-repo \
    --description "My new repo" \
    --public \
    --source=. \
    --remote=upstream
```
This will take the Git repository in your current directory (`--source=.`) and 
create a GitHub repository out of it. 

It will also create a new `git remote` called `upstream`, which points towards
the newly created GitHub repository.  




