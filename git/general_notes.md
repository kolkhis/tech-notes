
# Notes On Git  
Getting help on a git command: 
```bash  
man git[-command]  
# e.g.,
man git-stash  
# Or, for a more guided approach:
man gittutorial
man giteveryday
```

## Basic Git Commands  
The options lists for these aren't exhaustive.  
They're just examples.  

## Git Init
Initializes a new git repository in the current directory.
```bash
git init
```


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
By default, shows the changes to unstaged git files (already part of the repository).  
```bash
git diff  
```

* Show changes for cached / staged files  
  ```bash  
  git diff --cached  
  ```


### See changes from the current commit and the previous commit  
```bash
git diff commit1 commit2  
```
* Using `HEAD` will refer to the last commit you made.  
* Using `HEAD~1` will refer to the commit before that (think of it like `HEAD - 1`).  
    * `HEAD~2` will show 2 commits back, etc.  
```bash  
git diff HEAD HEAD~1   
```

---  

## Git Add  
`git add`  
Adds files to the staging area.  

---  

## Git Commit  
`git commit`  
Commits the staged files, and any changes made to them, to the repository.  
Running `git commit` without any options will open a text editor (determined  
by the `$EDITOR` environment variable) for you to write a commit message.  
* Options:
    * `-m` or `--message`: Allows you to pass the commit message on the command line.
    * `-a` or `--all`: Commits all files, including untracked files.
    * `-v` or `--verbose`: Shows the diff of the commit.
    * `-n` or `--dry-run`: Shows the diff of the commit, but doesn't actually commit.
    * `-e` or `--edit`: Allows you to edit the commit message in an editor.
    * `-s` or `--signoff`: Adds a "Signed-off-by" line to the commit message.
    * `--amend`: Allows you to amend the previous commit.
    * `--no-verify`: Allows you to skip the pre-commit and commit-msg hooks.
        * The pre-commit hook is used to check if the commit is valid.
        * The commit-msg hook is used to check if the commit message is valid.
    * `--allow-empty`: Allows you to commit an empty commit.
    * `--no-post-rewrite`: Allows you to skip the post-rewrite hook.
        * The post-rewrite hook is used to clean up the working tree after a merge.
    * `--no-gpg-sign`: Allows you to skip signing the commit with GPG.
    * `--no-status`: Allows you to skip updating the index file.
        * The index file is used to store information about the current state of the repository.
    * `--no-edit`: Allows you to skip the commit message editor.
    * `--template`: Allows you to specify a custom commit template.
    * `--cleanup`: Allows you to specify how to strip spaces and #comments from the message.
    * `--short`: Allows you to specify the number of characters to use when limiting the subject line.
    * `--no-rerere-autoupdate`: Skips updating the index with reused conflict resolution.
        * This means that the index will not be updated with reused conflict resolution.




---  

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

### See log history for a specific file or branch  
To see log history for a specific file, use `git log -p` or `git log --patch`.  
```bash  
git log -p README.md    # Show all commits for the file  
```

### See log history for a specific range of commits  
To see log history for a specific range of commits, use `git log commit1..commit2`.  
This uses a two-dot range notation (excludes endpoints).  
```bash  
git log HEAD~9..HEAD        # See the last 9 commits  
git log HEAD..origin/main   # See commits from the current branch to the main branch  
```
This shows what has happened between `commit1` and `commit2`, but not `commit2`.  

You can specify a three-dot range notation to see commits between two branches.  
This includes the endpoints.  
```bash  
git fetch  
git log HEAD...FETCH_HEAD  # Show commits from the current branch to the remote branch  
```
This means "show everything that is reachable from either one, but exclude anything that is  
reachable from both of them".  

### See log history for a forked repository  

```bash  
git remote add bobs_fork https://github.com/bob/bobs_fork.git  
git fetch bobs_fork  
git log -p main..bobs_fork/main  
```

---  

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

---  

## Git Checkout  
Switches branches or restores working tree files.  
```bash  
git checkout branch_name  
```
* Options:  
    * `-b [new-branch]`: Creates and switches to a new branch.  
    * `-- [file-name]`: Discards changes in the working directory for specific files.  

---  

## Git Merge  
Merges another branch into your current branch.  
```bash  
git merge branch_name  
```
* Options:  
    * `--no-ff`: Creates a merge commit even if a fast-forward merge is possible.  
    * `--abort`: Aborts the merge process in case of conflicts.  

---  

## Git Stash  
Temporarily stores modified, tracked files.  
```bash  
git stash  
```
* Options:  
    * `apply`: Applies the stashed changes back.  
    * `list`: Lists all stashed changes.  
    * `drop`: Deletes a specific stash.  

---  

## Git Fetch  
Purpose: Downloads objects and refs from a remote repository.  
```bash  
git fetch  
```
* Options:  
    * `--all`: Fetches from all remotes.  
    * `-p` or `--prune`: Deletes any remote-tracking references that no longer exist on the remote.  

---  

## Git Pull  
Purpose: Fetches from and integrates with another repository or local branch.  

The `pull` command performs two operations: 
1. It fetches changes from a remote branch.  
2. Then it merges them into the current branch.  
```bash  
git pull  
```
* Options:  
    * `--rebase`: Instead of merging, it rebases the current branch.  

---  

## Git Reset  
Resets current HEAD to a specified state.  
```bash  
git reset  
```
* Options:  
    * `--hard`: Resets the index and working tree. Any changes to tracked files are discarded.  
    * `--soft`: Does not touch the index file or the working tree.  
    * `[commit]`: Resets to a specific commit.  

---  

## Git Diff  
Shows changes between commits, commit and working tree, etc.  
```bash  
git diff  
```
* Options:  
    * `--[cached | staged]`: Shows changes in the staging area.  
    * `[commit1] [commit2]`: Compares two commits.  

---  

## Git Blame  
Shows what revision and author last modified each line of a file.  
```bash  
git blame [filename]  
```
* Options:  
    * `-L`: Restricts the annotation to a specified line range.  


---  

## Branches:  

## Creating a New Branch  
### Git Checkout / Git Switch / Git Branch  
There are three commands available to create a branch:  
```bash  
git branch newBranch  
git switch -c newBranch  
git checkout -b newBranch  
```

1. The first command (`branch`) creates a branch named `newBranch`.  
2. The second command (`switch -c`) creates the branch `newBranch` and switches to it.  
    * `switch` was created to replace the branch functionality of `checkout`, but
      `checkout` still has a lot of other uses.  
    * Prefer `git branch` and `git switch` over `git checkout -b` when working with branches.
3. The third command (`checkout -b`) also creates the branch `newBranch`, and then switches to it.  

## Renaming a Branch
Use `git branch -m` or `git branch -M` to rename a branch.
```bash
git branch -m oldBranch newBranch  # Safe renaming - won't overwrite an existing branch
git branch -M oldBranch newBranch  # Force renaming - will overwrite an existing branch
```
If `newBranch` already exists, it will *not* be overwritten unless you use the `-M` flag.
* `-m` is a shortcut for `--move`.
* `-M` is a shortcut for `--move --force`.


## List Branches
Use `git branch -l [pattern]` to list branches.
* The `[pattern]` is an *optional* pattern match that will filter branches by name.
```bash
git branch -l       # List all branches
git branch -l main  # List only the main branch
git branch -l 'm*'  # List all branches that start with 'm'
```
If you want to get the current branch's name, the `--show-current` flag will
print the name of the current branch.  

Combine other options with `-l` to match optional pattern(s):
* `-a`, `--all`: List both remote-tracking branches and local branches.
* `-v`, `-vv`, `--verbose`: Shows the current commit message, hash (SHA-1),
  and author of each branch.
* `-r`, `--remotes`: Shows the remote branch name.
    * Combine with `-d` to delete remote branches.


## Git Reset
### Rolling back to a previous commit
To roll back a git commit, use `git reset` with the either the `--soft` or `--hard` flag.
* `--soft`: Does not discard the changes made, leaves them in the staging area.
* `--hard`: Discards the changes made and removes them from the staging area.
    * **NOTE**: This permanently deletes your changes. Make sure you have a backup of your work before using this flag.

```bash
git reset --soft HEAD~1  # Rolls back to the previous commit, leaves changes in the staging area
```
* Before doing a reset, especially a hard reset, it's a good idea to ensure that you don't have any uncommitted changes that you want to keep.
    * You can check this with `git status`.
* If you've already pushed the commit to a remote repository and you perform a reset, you'll have to force push (`git push --force`) to update the remote repository.
    * Be cautious with this, as it can overwrite history on the remote and can impact others who have pulled the changes.


