
# Notes On Git  
Getting help on a git command: 
```bash  
man git[-command]  
# e.g.,
man git-stash  
```

## Basic Git Commands  
The options lists for these aren't exhaustive.  
They're just examples.  
## Git Status  
Shows the status of changes as untracked, modified, or staged.  
It's a quick way to see what changes are pending.  
```bash  
git status  
```
* Options:  
    * `--short` or `-s`: Gives a shorter, more succinct output.  
    * `--branch` or `-b`: Shows the branch and tracking information.  


## Git Diff  

## See changes from the current commit and the previous commit  
* Using `HEAD` will refer to the last commit you made.  
* Using `HEAD~1` will refer to the commit before that.  
    * `HEAD~2` will show 2 commits back, etc.  
    * Another notation is `HEAD^1`
```bash  
git diff HEAD HEAD~1  
```


## Git Log  
Shows the commit history.  
```bash  
git log  
```
* Options:  
    * `--oneline`: Condenses each commit to a single line, useful for a brief overview.  
    * `--graph`: Shows a text-based graphical representation of the commit history.  
    * `--all`: Shows all commits from all branches.  
    * `--author="name"`: Filters commits by a specific author.  
    * `--decorate`: Shows branch and tag names on commits.  


## Git Branch  
Lists, creates, or deletes branches.  
```bash  
git branch  
```
* Options:  
    * `-a`: Lists all branches, both local and remote.  
    * `-d`: Safely deletes a branch (only if it has been merged).  
    * `-D`: Force deletes a branch, even if it has unmerged changes.  
    * `-m`: Renames a branch.  


## Git Checkout  
Switches branches or restores working tree files.  
```bash  
git checkout branch_name  
```
* Options:  
    * `-b [new-branch]`: Creates and switches to a new branch.  
    * `-- [file-name]`: Discards changes in the working directory for specific files.  


## Git Merge  
Merges another branch into your current branch.  
```bash  
git merge branch_name  
```
* Options:  
    * `--no-ff`: Creates a merge commit even if a fast-forward merge is possible.  
    * `--abort`: Aborts the merge process in case of conflicts.  


## Git Stash  
Temporarily stores modified, tracked files.  
```bash  
git stash  
```
* Options:  
    * `apply`: Applies the stashed changes back.  
    * `list`: Lists all stashed changes.  
    * `drop`: Deletes a specific stash.  


## Git Fetch  
Purpose: Downloads objects and refs from a remote repository.  
```bash  
git fetch  
```
* Options:  
    * `--all`: Fetches from all remotes.  
    * `-p` or `--prune`: Deletes any remote-tracking references that no longer exist on the remote.  


## Git Pull  
Purpose: Fetches from and integrates with another repository or local branch.  
```bash  
git pull  
```
* Options:  
    * `--rebase`: Instead of merging, it rebases the current branch.  


## Git Reset  
Resets current HEAD to a specified state.  
```bash  
git reset  
```
* Options:  
    * `--hard`: Resets the index and working tree. Any changes to tracked files are discarded.  
    * `--soft`: Does not touch the index file or the working tree.  
    * `[commit]`: Resets to a specific commit.  


## Git Diff  
Shows changes between commits, commit and working tree, etc.  
```bash  
git diff  
```
* Options:  
    * `--[cached | staged]`: Shows changes in the staging area.  
    * `[commit1] [commit2]`: Compares two commits.  


## Git Blame  
Shows what revision and author last modified each line of a file.  
```bash  
git blame [filename]  
```
* Options:  
    * `-L`: Restricts the annotation to a specified line range.  


---  

## Branches:  
## Checkout / Switch / Branch  

### Creating a New Branch  
There are three commands available to create a branch:  
```bash  
git branch newBranch  
git checkout -b newBranch  
git switch -c newBranch  
```

1. The first command (`branch`) creates a branch named `newBranch`.  
1. The second command (`checkout -b`) creates the branch `newBranch`, and then switches to it.  
1. The third command (`switch -c`) also creates the branch `newBranch` and switches to it.  
    * `switch` was created to replace `checkout`, but `checkout` still has a lot of other uses.  




