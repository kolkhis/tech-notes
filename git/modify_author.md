
# Changing Git Commit History's Metadata


## Table of Contents
* [Changing the Author of the Last Commit](#changing-the-author-of-the-last-commit) 
* [Change the Author of Commits Using `git rebase`](#change-the-author-of-commits-using-`git-rebase`) 
    * [Modifying the First Commit (Root Commit)](#modifying-the-first-commit-(root-commit)) 
    * [Change the Author for a Range of Commits](#change-the-author-for-a-range-of-commits) 
    * [Change the Author for the Entire Project Repo History](#change-the-author-for-the-entire-project-repo-history) 
    * [Customizing Author Information](#customizing-author-information) 
* [Committer vs Author](#committer-vs-author) 
* [Change the Author for Single Commit](#change-the-author-for-single-commit) 


## Changing the Author of the Last Commit

You can specify a new author for the most recent commit with the `--author` flag:
```bash
git commit --amend --author="new author name"
```
This will also pull up your editor to change the commit message.  
To prevent opening the editor, add the `--no-edit` flag.  


If you want to, you can also use `--reset-author`:
```bash
git commit --amend --no-edit --reset-author
```

Using `--reset-author` updates both the `author` and `committer` details to the 
details in your current `.gitconfig` file.  

## Change the Author of Commits Using `git rebase`

First, if you haven't already, you will likely want to fix your name in your `.gitconfig`:  
```bash
git config --global user.name "New Author Name"
git config --global user.email "<email@address.example>"
```

This is optional, but it will also make sure to reset the committer's name too, assuming that's what you need.  

### Modifying the First Commit (Root Commit)
If you also need to modify the very first commit (root commit) in your history, add `--root` to the `git rebase` command: 
```bash
git rebase -i --root --exec 'git commit --amend --no-edit --reset-author'
```
With this you can be sure that the rebase includes the root commit.



### Change the Author for a Range of Commits
To rewrite metadata for a range of commits using a rebase:
```bash
git rebase -r <some commit before all of your bad commits> \
    --exec 'git commit --amend --no-edit --reset-author'


git rebase -i <commit before your first bad commit> \
    --exec 'git commit --amend --no-edit --reset-author'
```
* `git rebase` Command: 
    * `git rebase -i <commit>`: Initiates an interactive rebase starting from the specified `<commit>`.
    * `--exec` flag: `--exec` allows you to execute a shell command 
      (`git commit --amend --no-edit --reset-author`) after each commit is applied during 
      the rebase process.


`--exec` will run the git commit step after each commit is rewritten 
(as if you ran `git commit && git rebase --continue` repeatedly).  

If you also want to change your first commit (also called the 'root' commit),
you will have to add `--root` to the rebase call.  

This will change both the committer and the author to your `user.name`/`user.email` configuration.  
If you did not want to change that config, you can use:  
```bash
--author "New Author Name <email@address.example>"
```
instead of 
```bash
--reset-author  # Note that doing this won't update the committer, just the author.
```

### Change the Author for the Entire Project Repo History
```bash
git rebase -r --root --exec "git commit --amend --no-edit --reset-author"
```

### Customizing Author Information
If you need to set a specific author for all commits (instead of using the default `user.name` and `user.email`), use the `--author` option:
```bash
--author "New Author Name <email@address.example>"
```
If you only want to update the author and leave the committer unchanged, use the `--author` option instead.








