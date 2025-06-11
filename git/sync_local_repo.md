# Update your Local Repo

When working with a Git repository, you usually want to pull from your upstream often 
to make sure you've got the latest versions of all the files.

## Overview

Sometimes when you're trying to do a `git pull`, you have merge conflicts because
you've made changes.  

There are many ways to deal with merge conflicts, but there is an easy way to do this (no, not
`rm -rf ./repo && git clone repo`). You can rebase (e.g., `git pull --rebase`) and do 
the edits yourself, that's perfectly valid.  

But these are the steps I personally take when I want to sync my local repository 
with a remote and there are possible conflicts.  

> **NOTE**: This is not a fool-proof way of syncing. There can still be merge
> conflicts, and you still may need to deal with them by editing the files.  

## Steps

Let's say we have a `remote` called `upstream`.  

We want to sync with `upstream` but we've already made changes and committed them in
our local repo.  

We're going to assume, for the sake of this guide, that we know there are going to be
merge conflicts.  

So what we want to do is roll back to the last commit that **both repos have in
common**. Basically, roll back to the last commit that would not have merge
conflicts.  

1. Find the commit that you want to roll back to.  
   ```bash
   git log --oneline
   ```
   Go back to a commit from before you committed your out-of-sync changes.  
   For instance, if we see this output:
   ```text
   de23ef2 (HEAD -> main) docs: update morecmds.md
   6a0d953 feat: add new file morecmds.md
   55820ad (origin/main) docs; add cmds for session
   ```
   We see our `HEAD` (current working tree) is on the commit hash `de23ef2`.  
   We want to roll back to where `origin/main` is (two commits behind where we are now).  

1. Roll back your branch with a **soft** reset.  
   We can use either the exact commit hash (`55820ad`) OR we can do `HEAD~2` (roll back 
   by 2 commits).  
   ```bash
   git reset --soft HEAD~2
   ```
    - **NOTE**: The `--soft` is **very important**. If you were to do a **hard
      reset**, you'd lose all the changes you made!    

1. Now we're on the same commit. Run a `git status` and you'll see all the changes
   you made are still there.  
   ```bash
   git status
   # Changes to be committed:
   # (use "git restore --staged <file>..." to unstage)
   #      new file:   morecmds.md
   ```

1. Now that we're on the correct commit and our changes are still there, let's
   `stash` them.  
   ```bash
   git stash
   # Saved working directory and index state WIP on main: 55820ad docs; add cmds for session
   ```
   This puts your changes into the `stash` stack. View the stash with `git stash list`.    
   ```bash
   git stash list
   # stash@{0}: WIP on main: 55820ad docs: add cmds for session
   ```
   We'll be able to pop those changes out after we sync our local branch.  

1. Pull down the changes from your remote.  
   ```bash
   git pull upstream main
   ```
   Replace `upstream main` with whatever `remote` and `branch` you're using.  
   Your local branch should now be up to date with the remote branch.  

1. Pop your changes from the stash back into your working tree.  
   ```bash
   git stash pop
   # On branch main
   # Your branch is up to date with 'origin/main'.
   # 
   # Changes to be committed:
   #   (use "git restore --staged <file>..." to unstage)
   #         new file:   morecmds.md
   # 
   # Dropped refs/stash@{0} (4c8d90dc46cfab7994ce4b9e5f46f17ce2f54913)
   ```
   This takes the changes you stashed before and puts them back into the working
   tree.  
    - **NOTE**: At this point, conflicts may arise if you've changed the same files that
      were edited in the remote branch. If that happens, you may need to resolve
      those conflicts.  

1. Verify that your changes are there, and then re-commit them.  
   ```bash
   git commit -m "feat: add cmds for session"
   ```

Done! That's an easy way to sync your local fork without nuking your whole repo.  

Let's review the commands we used:

```bash
git reset --soft HEAD~2
git stash
git pull upstream main
git stash pop
git commit -m "feat: add cmds for session"
```

Five commands, not that bad.  


Hope this helps someone. Good luck!

