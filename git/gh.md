# The `gh` tool
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


## Authentication
After you first install `gh`, use the `gh auth login` command to set up
authentication.  

```bash
gh auth login
```
Go through the steps to login and you'll be able to use `gh` to manage 
your GitHub through the command line.  

## Cloning a Repository
