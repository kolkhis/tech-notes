
# Rolling Back to a Previous Git Commit

## Using Git Reset
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

### Fast Forwarding to HEAD
If you go back to a previous commit, using `reset` or something else, use `git merge`
to get back to the HEAD of the branch. 
```bash
git merge origin/main
```
