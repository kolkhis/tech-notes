# Git Operations
Getting help on a git command: 
```bash  
man git[-command]  
# e.g.,
man git-stash  
# Or, for a more guided approach:
man gittutorial
man giteveryday
```

Like all `bash` man pages, any parameters in brackets (`[like_this]`) are optional.




## Table of Contents
* [Basic Git Commands](#basic-git-commands) 
    * [`git init`](#git-init) 
    * [`git status`](#git-status) 
    * [`git diff`](#git-diff) 
    * [See changes from the current commit and the previous commit](#see-changes-from-the-current-commit-and-the-previous-commit) 
    * [`git add`](#git-add) 
    * [`git commit`](#git-commit) 
    * [`git log`](#git-log) 
    * [See log history for a specific file or branch](#see-log-history-for-a-specific-file-or-branch) 
    * [See log history for a specific range of commits](#see-log-history-for-a-specific-range-of-commits) 
    * [See log history for a forked repository](#see-log-history-for-a-forked-repository) 
    * [`git reflog:`](#git-reflog) 
    * [`git branch`](#git-branch) 
    * [`git checkout`](#git-checkout) 
    * [`git merge`](#git-merge) 
    * [`git stash`](#git-stash) 
    * [`git fetch`](#git-fetch) 
    * [`git pull`](#git-pull) 
    * [`git blame`](#git-blame) 
    * [`git reset`](#git-reset) 
    * [Rolling back to a previous commit](#rolling-back-to-a-previous-commit) 
* [Branches](#branches) 
* [Creating a New Branch](#creating-a-new-branch) 
    * [Git Checkout / Git Switch / Git Branch](#git-checkout--git-switch--git-branch) 
* [Renaming a Branch](#renaming-a-branch) 
* [List Branches](#list-branches) 
    * [`git remote`](#git-remote) 
    * [`git archive:`](#git-archive) 



## Basic Git Commands  
The options lists for these aren't exhaustive.  
They're just examples.  
 
### `git init`
Initializes a new git repository in the current directory.
```bash
git init
```


### `git status`
Shows the status of changes as untracked, modified, or staged.  
It's a quick way to see what changes are pending.  
```bash  
git status  
```

Options:  

* `--short` or `-s`: Gives a shorter output.  
* `--branch` or `-b`: Shows the branch and tracking information.  

* `--show-stash`: Show the number of entries currently stashed away.
* `--long`: Give the output in the long-format. This is the default.
* `-v, --verbose`:
    * Show the names of file *and* the changes that are staged to be committed 
      (like `git diff --cached`).
    * If `-vv` is specified, also show the changes in the working
      tree that have not yet been staged (like `git diff`).
* `-u[<mode>], --untracked-files[=<mode>]`:
    * Show untracked files.
    * The `mode` is optional. The possible `mode`s are:
        * `no` - Show no untracked files.
        * `normal` - Shows untracked files and directories.
        * `all` - Also shows individual files in untracked directories.
    * If this is specified, the mode needs to be "stuck" to the option.
        * E.g., GOOD: `git status -uall` (will work), BAD: `git status -u all` (will not work).  


---

### `git diff`
By default, show the changes to unstaged **git** files (already part of the repository).
  
Shows changes between commits, commit and working tree, etc.  
```bash
git diff  
```
Options:  

* `--[cached | staged]`: Shows changes in the staging area.  
* `[commit1] [commit2]`: Compares two commits.  

* Show changes for cached / staged files  
  ```bash  
  git diff --cached  
  ```


---  

### See changes from the current commit and the previous commit  
```bash
git diff commit1 commit2  
```

* Using `HEAD` will refer to the last commit you made.  
* Using `HEAD~1` will refer to the commit before that (think of it like `HEAD - 1`).  
    * `HEAD~2` will show 2 commits back, etc.  

```bash  
git diff HEAD HEAD~1   
# or:
git diff HEAD~1   
```
The first `HEAD` is optional. It is implied by default.  

---  

### `git add`
`git add`  
Adds files to the staging area.  

---  

### `git commit`

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

### `git log`
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

### `git reflog:`
Use when you want to see all actions taken in the repo, 
even those not visible in `git log`.  
Great for finding older commit hashes.
```bash
git reflog
```


---  

### `git branch`
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

### `git checkout`
Switches branches or restores working tree files.  
```bash  
git checkout branch_name  
```

* Options:  
    * `-b [new-branch]`: Creates and switches to a new branch.  
    * `-- [file-name]`: Discards changes in the working directory for specific files.  

---  

### `git merge`
Merges another branch into your current branch.  
```bash  
git merge branch_name  
```

* Options:  
    * `--no-ff`: Creates a merge commit even if a fast-forward merge is possible.  
    * `--abort`: Aborts the merge process in case of conflicts.  

---  

### `git stash`
Temporarily stores modified, tracked files.  
```bash  
git stash  
```
* Options:  
    * `apply`: Applies the stashed changes back.  
    * `list`: Lists all stashed changes.  
    * `drop`: Deletes a specific stash.  

---  

### `git fetch`
Downloads branches and tags from a remote repository.  
```bash  
git fetch [remote] [branch]
```

* Options:  
    * `--all`: Fetches from all remotes.  
    * `-p` or `--prune`: Deletes any remote-tracking references that no longer exist on 
      the remote.  
        - Good for updating deleted branches.  
    - `--dry-run`: Show what would happen without actually doing it.  
    - `-t`: Fetch all tags from the remote.  

---  

### `git pull`
Fetches from and integrates with another repository or local branch.  

The `pull` command performs two operations: 

1. It `fetch`es changes from a remote branch.  
2. Then it `merge`s them into the current branch.  

```bash  
git pull [remote] [branch]
```

* Options:  
    * `--rebase`: Instead of merging, it rebases the current branch.  

---  


### `git blame`
Shows what revision and author last modified each line of a file.  
```bash  
git blame [filename]  
```

* Options:  
    * `-L`: Restricts the annotation to a specified line range.  

---

### `git remote`
`git remote` refers to a remote repository.  
A remote is a repository that is hosted on a server (e.g., GitHub, BitBucket, etc.).  
To link a remote repository to a local repository:  
```bash
git remote add origin https://remote-repo.url.git       # For HTTS
git remote add origin git@github.com:username/repo.git  # For SSH
```
It's important to add `.git` to the end of the remote repository URL.  

---

### `git archive:`
* This is used for fetching files without cloning the entire 
  repository, `git archive` can be used to create a zip/tar archive of
  specific files or directories.
  ```bash
  git archive --remote=ssh://git@{repo_url} {branch_name} {file_path} | tar -xO > {local_file_path}
  ```

---

### `git reset`
Resets current `HEAD` to a specific commit or state.  
* This can be dangerous, but is powerful for undoing changes.
```bash  
git reset  
```
Options:  
* `--hard`: Resets the index and working tree. Any changes to tracked files are discarded.  
* `--soft`: Does not touch the index file or the working tree.  
* `[commit]`: Resets to a specific commit.  

  ```bash
  git reset --hard {commit_hash}
  ```
    * `--hard` discards the changes.
    * Using `--soft` will keep the changes, but will not change the `HEAD`.


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



--- 


## Configure Git to use SSH by Default
Configure Git to use SSH instead of HTTPS by default.  
```bash
git config --global url.ssh://git@github.com/.insteadOf https://github.com/
```


