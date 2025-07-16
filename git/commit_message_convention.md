# Git Commit Message Convention

This is a widely debated topic. Everyone has their own way of writing commit
messages. That said, git commit messages should be in a standardized format.  
A lot of people follow the standards outlined on this page.  

## Git Commit Message Structure

The commit message should be structured like this:
```git
[type]: [description]

[body]
```

### Commit Types

`[type]`: Indicates the type of the commit. It should be one of the following:

* `feat`: A new feature is introduced with the changes
* `fix`: A bug fix has occurred
* `chore`: Changes that do not relate to a fix or feature and don't modify src or test files (for example updating dependencies)
* `refactor`: Refactored code that neither fixes a bug nor adds a feature
* `docs`: Updates to documentation such as a the README or other markdown files
* `style`: Changes that do not affect the meaning of the code, likely related to code formatting such as white-space, missing semi-colons, and so on.
* `test`: Including new or correcting previous tests
* `perf`: Performance improvements
* `ci`: Continuous integration related
* `build`: Changes that affect the build system or external dependencies
* `revert`: Reverts a previous commit 

### Commit Description

The `[description]` should be a short, concise, one-line message that gives a brief 
overview of what was changed.  

The description should start with a capitalized verb and should not exceed 50 characters.

---

It's common for git commit descriptions to be in the present tense rather than the 
past tense.  

For example:
```bash
git commit -m "docs: Add section describing installation process"
```
This uses the present tense, rather than:
```bash
git commit -m "docs: Added section describing the installation process"
```

It really only becomes past tense when it is merged into the primary branch. So until
then, it's present tense.  


### Commit Body

The `[body]` (optional) is a more detailed description of the changes made in the commit.

This is the extended description where you go into detail about what you changed and
how it affects other things.  

When opening a PR on GitHub, the commit body will be used by default as the body for
the PR. This is pulled from the commit body for the last commit in the branch that 
you're opening the PR from. So this can save you some time by writing it ahead of 
time.  



### Full Commit Example
Example of a full git commit message:
```git
fix: Fix foo to enable bar

This fixes the broken behavior of the component by doing xyz.

BREAKING CHANGE
Before this fix foo wasn't enabled at all, behavior changes from <old> to <new>

Closes #135
```



