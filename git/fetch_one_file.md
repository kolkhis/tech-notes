# Pull one file from your Git repository


## Table of Contents
* [Recover a singular file from a previous commit](#recover-a-singular-file-from-a-previous-commit) 
    * [The `git restore` Method (the "Modern Approach")](#the-`git-restore`-method-(the-"modern-approach")) 
    * [The fetch method](#the-fetch-method) 
    * [The `git checkout` Method](#the-`git-checkout`-method) 
        * [Getting a File from a Previous Commit](#getting-a-file-from-a-previous-commit) 
        * [Getting a File from the Current Branch's History](#getting-a-file-from-the-current-branch's-history) 
        * [Getting a File from a Remote Branch](#getting-a-file-from-a-remote-branch) 
    * [Other Relevant Git Commands](#other-relevant-git-commands) 


## Recover a singular file from a previous commit

### The `git restore` Method (the "Modern Approach")
Using `git restore` is now the preferred way to recover files from a previous commit.  
You can use `git restore` to restore a specific file from a particular commit

1. Get the hash of the commit where the version of the file you want is located.  
   ```bash
   git log --oneline
   ```

2. Restore the file from a specific commit.
   ```bash
   git restore --source={commit_hash} -- {file_path}  
   ```
    * `{commit_hash}` is the hash of the commit you want to restore from. 
    * `{file_path}` is the **relative** path to the file you want to restore.

3. Stage and commit the file.
```bash
git add {file_path} && git commit -m "fix: Restore {file_path} from {commit_hash}"
```

Done.

---

### The fetch method
1. Get the hash of the commit from where you want to pull your file.
  ```bash
  git branch -v
  ```

2. Call fetch
  ```bash
  git fetch
  ```

3. Checkout the file you want from the commit
  ```bash
  git checkout -m {revision} {the_file_path}
  ```
   - `{revision}` is the hash of the commit
   - `{the_file_path}` is the path to the file you want. Does not include repo name.

4. Add and commit the file
```bash
git add the_file_path
git commit
```

5. Done.


### The `git checkout` Method
`git checkout` is "deprecated", but still works. 

#### Getting a File from a Previous Commit
If you want to check out a file from a specific commit:
```bash
git checkout {commit_hash} -- {file_path}
```

#### Getting a File from the Current Branch's History
To get a file's version from the current branch in your local repo (e.g., `main`):
```bash
git checkout main -- {file_path}
```

* Replace `main` with the name of the branch (if it's different).


#### Getting a File from a Remote Branch
If you want a file from a remote branch in a remote repo (e.g., `origin/main`):
```bash
git checkout origin/main -- {file_path}
```

* Replace `main` with the name of the branch (if it's different).


### Pulling with `git archive`
This method is a bit more verbose, but it doesn't overwrite the local version of the file you're trying to pull.  

* `git archive`: 
    * You can use the `git archive` command to extract a specific file from the remote repository without pulling the whole repository.  
    * `git archive` can also be used to create a zip/tar archive of specific files or directories.  
      ```bash
      git archive --remote=ssh://git@{repo_url} {branch_name} {file_path} | tar -xO > {local_file_path} 
      ```
    * This command fetches the file at `{file_path}` from `{branch_name}` on the remote repository at `{repo_url}` and saves it as `{local_file_path}`.  
