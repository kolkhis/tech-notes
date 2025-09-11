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
You can also hit `<Tab><Tab>` (trigger completion) to see available commands along 
the way.  

In addition to the help text, each `gh` subcommand has its own `man` page.  
```bash
man gh-repo
man gh-repo-create
man gh-repo-sync
man gh-pr
man gh-pr-view
```


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

The `repo` subcommand also has a number of other subcommands:

- `archive`
- `clone`
- `create`
- `delete`
- `edit`
- `fork`
- `list`
- `rename`
- `sync`
- `view`

These subcommands are pretty self-explanatory for what they do.  

See `man gh-repo` for what they each do.  

### Cloning a Repository

```bash
gh repo clone username/repo-name
```

You only have to specify the `username` and `repo-name`, not the full
`github.com` path.

### Creating a Repository
You can create a new repository on GitHub without opening your web browser with
`gh`.  

```bash
gh repo create
```

This will launch an interactive program that will let you configure your new
repository.  


