
# `git checkout`

This command is being deprecated in favor of more appropriately named alternatives.  
The `checkout` command seems to be a sort of Swiss Army Knife for all sorts of
different operations.  

It's being replaced in favor of less ambiguous commands.  


## Alternatives to `git checkout` for Various Operations

### Switching Branches:  
Use `git switch` instead of `git checkout` for switching branches.  
It's way more straightforward.
```bash
git switch {branch_name}
```
* Use `git switch {branch_name}` for switching to an existing branch. 
* `git switch -c {branch_name}` for creating and switching to a new branch.

### Restoring Files:  
Use `git restore` instead of `git checkout` to recover files from specific commits, 
branches, or the working directory.
```bash
git restore --source={commit_hash/branch_name} -- {file_path}
```
This will restore the file at `{file_path}` to the state it was in at the `--source`
commit.  

### Unstaging Changes:  
If you want to unstage a file (previously done with `git checkout`), use `git restore --staged`.
```bash
git restore --staged {file_path}
```
This command will unstage the `{file_path}` file, while leaving the file's changes 
intact in your working directory.


### Discarding Changes in the Working Directory:  
To discard changes in the working directory, use:
```bash
git restore {file_path}
```

