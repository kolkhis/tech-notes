
# Pull one file from your Git repository

## Recover a singular file from a previous commit

### The fetch method
1. Get the hash of the commit from where you want to pull your file.
```bash
git branch -v
```
1. Call fetch
```bash
git fetch
```
1. Checkout the file you want from the commit
```bash
git checkout -m {revision} {the_file_path}
```
* `{revision}` is the hash of the commit
* `{the_file_path}` is the path to the file you want. Does not include repo name.
1. Add and commit the file
```bash
git add the_file_path
git commit
```
1. Done.


### The simple checkout method
* Getting from local repository:
```bash
git checkout main -- {filename}
```
* Getting from remote repository:
```bash
git checkout origin/main -- {filename}
```
Replace `main` with the name of the branch.
