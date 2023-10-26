
# Git Commit Message Conventions

## Commit Types
* `feat` – a new feature is introduced with the changes
* `fix` – a bug fix has occurred
* `chore` – changes that do not relate to a fix or feature and don't modify src or test files (for example updating dependencies)
* `refactor` – refactored code that neither fixes a bug nor adds a feature
* `docs` – updates to documentation such as a the README or other markdown files
* `style` – changes that do not affect the meaning of the code, likely related to code formatting such as white-space, missing semi-colons, and so on.
* `test` – including new or correcting previous tests
* `perf` – performance improvements
* `ci` – continuous integration related
* `build` – changes that affect the build system or external dependencies
* `revert` – reverts a previous commit 


### Full Commit Example
Example of a full git commit message:
```git
fix: Fix foo to enable bar

This fixes the broken behavior of the component by doing xyz.

BREAKING CHANGE
Before this fix foo wasn't enabled at all, behavior changes from <old> to <new>

Closes D2IQ-12345
```
