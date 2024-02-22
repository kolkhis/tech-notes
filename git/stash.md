
# Git Stash

Git stash is a way to save your local changes without committing them.  
It's like making a save point.  

If you need to roll back but want to keep your changes, you can
use `git stash` to save your changes and then `git stash pop` to 
restore them.

## Git Stash Commands

Specify a specific stash item for these commands with `git stash <cmd> stash@{<n>}`
* `git stash` - Save the state of your local changes in a stash
    * This is shorthand for `git stash push`
    * This can accept a path to file(s) or a directory, and stash only the
      files that match the path (only when `push` is included).
        * e.g., `git stash push path/to/file`
* `git stash pop` - Restore the local changes from the stash, and remove it from the stash list.
* `git stash apply` - Same as `pop`, but doesn't remove the stash from the list.
* `git stash show` - Show the diff for the stash at the top of the stash list.
    * It will accept any format known to `git diff`
* `git stash drop` - Remove a single stash entry from the stash list.  
* `git stash clear` - Remove all the stash entries. 

```bash
git stash      # Save the state of your local changes in a stash
git stash pop  # Restore the local changes from the stash, and remove it from the stash list.

git stash -m "This is a stash message"  # A message that will show up in `git stash list`
git stash list  # List all stashes in the stash list
git stash pop stash@{1}  # Pop the stash with the given index

git stash show     # Show the truncated diff for the stash at the top of the stash list
git stash show -p  # Show the full diff for the stash at the top of the stash list

git stash push ./stash.md  # Only stash the given file
```

