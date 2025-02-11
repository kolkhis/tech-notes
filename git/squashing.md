# Squashing Commits
Squashing refers to combining multiple commits into one.  
Squashing is a good way to clean up commit history, reduce noise in PRs, fixing
commit mistakes, etc..  


There is no actual `git squash` command.  
You'd typically do this with `git rebase -i` or `git merge --squash`.  

---

When to squash:
- Working on a feature branch before merging to `main`.  
- To clean up commit history after experimenting.  
- When submitting changes for review.  
    - Teams often require squashing before merging.  
- When a single commit makes more sense than multiple small commits.  

## Table of Contents
* [Squash Commits from the CLI](#squash-commits-from-the-cli) 
    * [Using Interactive Rebase](#using-interactive-rebase) 
    * [Squash During a Merge](#squash-during-a-merge) 
* [Squashing Best Practices](#squashing-best-practices) 


## Squash Commits from the CLI

There are two main ways to do this.  
You can either use an interactive rebase (`git rebase -i HEAD~n`), or squash during a
merge (`git merge --squash some-branch`).  


### Using Interactive Rebase
```bash
git rebase -i HEAD~N  # where N is the number of commits to go back 
```

E.g., to squash the last 3 commits:
```bash
git rebase -i HEAD~3
```

This will open an interactive editor with a list of commits.  
```bash
pick 1234567 First commit
pick 89abcde Second commit
pick fefc123 Third commit
```

To squash these, change `pick` to `squash` (or just `s`) for all but the first commit
```bash
pick 1234567 First commit
squash 89abcde Second commit
squash fefc123 Third commit
```
After saving, Git will prompt you to edit the commit message.
This is the commit message that all the squashed commits will be under.  

---

### Squash During a Merge
To merge a branch into `main` while squashing:
```bash
git switch main
git merge --squash other-branch
git commit -m "Merged other-branch with a single commit"
```

## Squashing Best Practices
- Use before pushing (or be ready to force push).  
- Use when merging feature branches to keep history clean.  
- **Don't** squash commits in a shared branch unless it's necessary (it rewrites history).  
- **Don't** use `git rebase -i` if you're unsure. Backup or create a branch first.  


