# Git Branches  

## Working with Branches
Working with Git branches always used to be done with `checkout`.  
The modern way to work with branches is with `branch`/`switch`.  

### Creating Git Branches  
Create a branch using:  
```bash
git branch branch-name
# or
git switch -c branch-name
```
The first one will just create the branch with the given `branch-name`.  
The second will both create and switch to the new branch.  


### Switch Branch
Use `git switch` to switch to a given branch.  
```bash
git switch branch-name
```

### List Branches
Get a list of all the current branches with `branch -l`.  
```bash
git branch -l
```
This shows all the branches that exist locally.  


### Update Branch References
#### Prune deleted remote branches  
When a branch is deleted remotely, you'll need to update your local references.  
```bash
git fetch --prune
```
This should update the current refs.  

Or, to be more explicit:
```bash
git remote prune origin
```
This assumes the branch was deleted in the `origin` remote.  

---

#### Prune deleted local branches
If you've ever switched to the branch before, it might still exist in the Git reflog.  
```bash
git reflog --expire=now --all
git gc --prune=now
```
* `git reflog --expire=now --all`: 
* `git gc --prune=now`: This cleans up unnecessary files.  
    * `--prune` prunes "loose" objects. This is on by default.  

Check if the branch still exists.  
```bash
git show-ref | grep -i branch-name
```

If the branch still isn't gone, delete it manually from `.git/refs/heads/`
```bash
rm -rf .git/refs/heads/branch-name
```


