# Completely Removing a File from Git Commit History

Sometimes you need to wipe file from a Git repo.  
This is useful for large files or other unwanted files that accidentally ended up in a git repo.  

There is a tool made for this called `git filter-repo`.  

## Installing `git-filter-repo`
```bash
sudo apt install git-filter-repo
```

Or, install manually via Python:
```bash
pip install git-filter-repo
```

---

## Removing the File

Optionally, make a backup just in case.  
```bash
cp -r repo backup_repo
```

Then use `filter-repo`
```bash
git filter-repo --path path/to/file --invert-paths
```
* `--path path/to/file`: The file you want to remove
* `--invert-paths`: Inverts filtering logic, which means everything *except* the specified file is kept.  


Then force push.  
```bash
git push origin main --force --all
```

Optionally, clean up old references so that nothing is referencing the deleted file.  
```bash
rm -rf .git/refs/original
git reflog expire --expire=now --all
git gc --prune=now
```



## Using `git filter-branch`
This is considered deprecated, but it still works.  
```bash
git filter-branch --force --index-filter "git rm --cached --ignore-unpatch path/to/file" \
    --prunce-empty --tag-name-filter cat -- --all
```
This rewrites the history, removing the file from all commits

---

## Using `git rebase`
You can use `rebase` for this, and could be easier if you just need to work with
recent commits.  


Find the commit hash where the file was added:
```bash
git log -- path/to/file
```

Interactively rebase to remove the commit:
```bash
git rebase -i commit-hash^
```
* Change `pick` to `edit` for the commit that added the file.  


Remove the file and amend the commit:
```bash
git rm --cached path/to/file
git commit --amend --no-edit
```

Then continue the rebase process:
```bash
git rebase --continue
```

Force push the changes when you're done:
```bash
git push --force origin main
```



